#+build windows
package odinlings

import win "core:sys/windows"

@(private = "file")
orig_mode: win.DWORD
@(private = "file")
raw_enabled: bool

@(private = "file")
stdin_handle :: proc "contextless" () -> win.HANDLE {
	return win.GetStdHandle(win.STD_INPUT_HANDLE)
}

// Turns off line buffering and echo so single key presses can be read.
enable_raw_input :: proc() -> bool {
	if raw_enabled {
		return true
	}
	h := stdin_handle()
	if !win.GetConsoleMode(h, &orig_mode) {
		return false
	}
	if !win.SetConsoleMode(h, orig_mode & ~(win.ENABLE_LINE_INPUT | win.ENABLE_ECHO_INPUT)) {
		return false
	}
	raw_enabled = true
	return true
}

restore_input :: proc "contextless" () {
	if raw_enabled {
		win.SetConsoleMode(stdin_handle(), orig_mode)
		raw_enabled = false
	}
}

// Waits up to `timeout_ms` milliseconds (-1 = forever) for a key press.
read_key :: proc(timeout_ms: int) -> (ev: Key_Event, ok: bool) {
	h := stdin_handle()
	wait := win.INFINITE if timeout_ms < 0 else win.DWORD(timeout_ms)
	for {
		if win.WaitForSingleObject(h, wait) != win.WAIT_OBJECT_0 {
			return
		}
		rec: win.INPUT_RECORD
		n: win.DWORD
		if !win.ReadConsoleInputW(h, &rec, 1, &n) || n == 0 {
			return
		}
		if rec.EventType != .KEY_EVENT {
			if timeout_ms == 0 {
				return
			}
			continue
		}
		k := rec.Event.KeyEvent
		if !k.bKeyDown {
			if timeout_ms == 0 {
				return
			}
			continue
		}
		switch k.wVirtualKeyCode {
		case win.VK_UP:
			return {key = .Up}, true
		case win.VK_DOWN:
			return {key = .Down}, true
		case win.VK_RETURN:
			return {key = .Enter}, true
		case win.VK_ESCAPE:
			return {key = .Escape}, true
		}
		c := rune(k.uChar.UnicodeChar)
		if c == 3 {
			return {key = .Ctrl_C}, true
		}
		if c != 0 {
			return {key = .Char, ch = c}, true
		}
		if timeout_ms == 0 {
			return
		}
	}
}

// Discards keys that were pressed while an exercise was running.
drain_input :: proc() {
	win.FlushConsoleInputBuffer(stdin_handle())
}

// Whether standard input is an interactive console.
stdin_is_terminal :: proc() -> bool {
	mode: win.DWORD
	return bool(win.GetConsoleMode(stdin_handle(), &mode))
}
