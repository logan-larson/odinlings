package odinlings

import "core:os"
import "core:strings"
import "core:sync"
import "core:time"

Cmd_Result :: struct {
	exit_code: int,
	exited:    bool,
	timed_out: bool,
}

// `os.process_start` is not thread-safe (handle inheritance), so spawns from
// the `check-all` worker threads are serialized.
@(private = "file")
spawn_mutex: sync.Mutex

// Runs `command` with `working_dir` ("" = current directory). Standard output
// and standard error share one pipe so their order is preserved, and
// everything the process prints is appended to `output`. The process is
// killed when it runs longer than `timeout`.
run_cmd :: proc(
	command: []string,
	working_dir: string,
	output: ^strings.Builder,
	timeout: time.Duration,
) -> (
	res: Cmd_Result,
	err: os.Error,
) {
	r, w := os.pipe() or_return
	defer os.close(r)

	process: os.Process
	{
		sync.mutex_lock(&spawn_mutex)
		defer sync.mutex_unlock(&spawn_mutex)
		// Close our copy of the write end no matter what, otherwise reading
		// never reaches the end of the stream.
		defer os.close(w)
		process = os.process_start({command = command, working_dir = working_dir, stdout = w, stderr = w}) or_return
	}

	buf: [4096]byte
	start := time.tick_now()
	exited := false
	exited_at: time.Tick
	read_loop: for {
		for {
			has_data, perr := os.pipe_has_data(r)
			if perr != nil || !has_data {
				if perr != nil {
					break read_loop
				}
				break
			}
			n, rerr := os.read(r, buf[:])
			if n > 0 {
				strings.write_bytes(output, buf[:n])
			}
			if rerr != nil {
				break read_loop
			}
		}

		if !exited {
			state, _ := os.process_wait(process, 0)
			if state.exited {
				exited = true
				res.exit_code = state.exit_code
				res.exited = true
				exited_at = time.tick_now()
				// Keep reading until the pipe reports end of stream; a child of
				// the process may still be writing.
				continue
			}
		}

		// After the process exited, a process it started could still hold the
		// pipe open. Don't wait for it for long.
		if exited && time.tick_since(exited_at) > time.Second {
			break
		}
		if time.tick_since(start) > timeout {
			if !exited {
				_ = os.process_kill(process)
				res.timed_out = true
			}
			break
		}
		time.sleep(5 * time.Millisecond)
	}

	if !exited {
		state, _ := os.process_wait(process)
		res.exit_code = state.exit_code
		res.exited = state.exited && !res.timed_out
	}

	if strings.builder_len(output^) > 0 && !strings.has_suffix(strings.to_string(output^), "\n") {
		strings.write_byte(output, '\n')
	}
	return
}
