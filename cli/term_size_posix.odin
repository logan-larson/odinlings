#+build linux, darwin, freebsd, netbsd, openbsd
package odinlings

import "core:c"

when ODIN_OS == .Darwin {
	foreign import libc "system:System"
} else {
	foreign import libc "system:c"
}

@(private = "file")
foreign libc {
	ioctl :: proc(fd: c.int, request: c.ulong, #c_vararg args: ..any) -> c.int ---
}

@(private = "file")
Winsize :: struct {
	ws_row:    u16,
	ws_col:    u16,
	ws_xpixel: u16,
	ws_ypixel: u16,
}

when ODIN_OS == .Linux {
	@(private = "file")
	TIOCGWINSZ :: 0x5413
} else {
	@(private = "file")
	TIOCGWINSZ :: 0x40087468
}

_term_size :: proc() -> (width, height: int, ok: bool) {
	ws: Winsize
	if ioctl(1, TIOCGWINSZ, &ws) == 0 && ws.ws_col > 0 {
		return int(ws.ws_col), int(ws.ws_row), true
	}
	return
}
