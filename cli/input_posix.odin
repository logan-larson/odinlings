#+build linux, darwin, freebsd, netbsd, openbsd
package odinlings

import "core:sys/posix"

@(private = "file")
orig_termios: posix.termios
@(private = "file")
raw_enabled: bool

// Turns off line buffering and echo so single key presses can be read. Ctrl-C
// keeps working; the handler restores the terminal before exiting.
enable_raw_input :: proc() -> bool {
	if raw_enabled {
		return true
	}
	if posix.tcgetattr(posix.STDIN_FILENO, &orig_termios) != .OK {
		return false
	}
	t := orig_termios
	t.c_lflag -= {.ICANON, .ECHO}
	t.c_cc[.VMIN] = 1
	t.c_cc[.VTIME] = 0
	if posix.tcsetattr(posix.STDIN_FILENO, .TCSANOW, &t) != .OK {
		return false
	}
	raw_enabled = true
	posix.signal(.SIGINT, proc "c" (_: posix.Signal) {
		restore_input()
		// Show the cursor again and leave the alternate screen, in case the
		// list view was open.
		s := "\x1b[?25h\x1b[?1049l\n"
		posix.write(posix.STDOUT_FILENO, raw_data(s), len(s))
		posix._exit(130)
	})
	return true
}

restore_input :: proc "contextless" () {
	if raw_enabled {
		posix.tcsetattr(posix.STDIN_FILENO, .TCSANOW, &orig_termios)
		raw_enabled = false
	}
}

@(private = "file")
read_byte :: proc(timeout_ms: int) -> (b: byte, ok: bool) {
	fds := [1]posix.pollfd{{fd = posix.STDIN_FILENO, events = {.IN}}}
	if posix.poll(&fds[0], 1, i32(timeout_ms)) <= 0 {
		return
	}
	if posix.read(posix.STDIN_FILENO, &b, 1) != 1 {
		return
	}
	return b, true
}

// Waits up to `timeout_ms` milliseconds (-1 = forever) for a key press.
read_key :: proc(timeout_ms: int) -> (ev: Key_Event, ok: bool) {
	b := read_byte(timeout_ms) or_return
	switch b {
	case 3:
		return {key = .Ctrl_C}, true
	case '\n', '\r':
		return {key = .Enter}, true
	case 0x1b:
		// An arrow key arrives as ESC [ A/B/C/D.
		next, has_next := read_byte(20)
		if !has_next {
			return {key = .Escape}, true
		}
		if next == '[' || next == 'O' {
			code, _ := read_byte(20)
			switch code {
			case 'A':
				return {key = .Up}, true
			case 'B':
				return {key = .Down}, true
			}
		}
		return {key = .None}, true
	case:
		return {key = .Char, ch = rune(b)}, true
	}
}

// Discards keys that were pressed while an exercise was running.
drain_input :: proc() {
	for {
		if _, ok := read_byte(0); !ok {
			break
		}
	}
}

// Whether standard input is an interactive terminal.
stdin_is_terminal :: proc() -> bool {
	return bool(posix.isatty(posix.STDIN_FILENO))
}
