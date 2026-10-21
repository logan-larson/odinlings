package odinlings

import "base:runtime"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:sync"
import "core:sync/chan"
import "core:thread"

Run_Job :: struct {
	idx:  int,
	info: Exercise_Info,
	opts: Run_Options,
}

Run_Done :: struct {
	idx:     int,
	success: bool,
	output:  string, // only kept when `keep_output` is set; heap-allocated
}

@(private = "file")
Worker_Shared :: struct {
	tool:        ^Odin_Tool,
	jobs:        []Run_Job,
	next:        int, // index of the next unclaimed job, claimed atomically
	results:     chan.Chan(Run_Done),
	keep_output: bool,
}

// How many exercises to check at the same time. Each `odin` process uses
// several threads itself, so only half of the cores are used. The
// ODINLINGS_JOBS environment variable overrides this.
worker_count :: proc() -> int {
	buf: [16]u8
	if s, err := os.lookup_env(buf[:], "ODINLINGS_JOBS"); err == nil {
		if n, ok := strconv.parse_int(s); ok && n > 0 {
			return n
		}
	}
	return clamp(os.get_processor_core_count() / 2, 1, 4)
}

// Runs all jobs on a pool of worker threads. `allocator` is only used on the
// calling thread, for the returned slice. `on_done` is called on the
// calling thread once per finished job, in completion order. The returned
// results are in completion order as well.
run_many :: proc(
	tool: ^Odin_Tool,
	jobs: []Run_Job,
	on_done: proc(data: rawptr, d: Run_Done),
	data: rawptr,
	keep_output := false,
	allocator := context.allocator,
) -> []Run_Done {
	results := make([]Run_Done, len(jobs), allocator)
	if len(jobs) == 0 {
		return results
	}

	shared := Worker_Shared {
		tool        = tool,
		jobs        = jobs,
		keep_output = keep_output,
	}
	err: runtime.Allocator_Error
	shared.results, err = chan.create_buffered(chan.Chan(Run_Done), len(jobs), context.allocator)
	assert(err == nil)
	defer chan.destroy(shared.results)

	n_workers := min(worker_count(), len(jobs))
	threads := make([]^thread.Thread, n_workers, context.temp_allocator)
	for &t in threads {
		t = thread.create_and_start_with_poly_data(&shared, worker_proc)
	}

	for i in 0 ..< len(jobs) {
		d, ok := chan.recv(shared.results)
		assert(ok)
		results[i] = d
		if on_done != nil {
			on_done(data, d)
		}
	}

	for t in threads {
		thread.join(t)
		thread.destroy(t)
	}
	return results
}

@(private = "file")
worker_proc :: proc(shared: ^Worker_Shared) {
	output := strings.builder_make()
	defer strings.builder_destroy(&output)
	for {
		i := sync.atomic_add(&shared.next, 1)
		if i >= len(shared.jobs) {
			break
		}
		job := shared.jobs[i]
		success := run_exercise(shared.tool, job.info, &output, job.opts)
		done := Run_Done{idx = job.idx, success = success}
		if shared.keep_output {
			// The heap allocator is thread-safe; the receiver owns this string.
			done.output = strings.clone(strings.to_string(output), runtime.heap_allocator())
		}
		chan.send(shared.results, done)
		free_all(context.temp_allocator)
	}
}
