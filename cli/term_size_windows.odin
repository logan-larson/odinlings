#+build windows
package odinlings

import win "core:sys/windows"

_term_size :: proc() -> (width, height: int, ok: bool) {
	info: win.CONSOLE_SCREEN_BUFFER_INFO
	if win.GetConsoleScreenBufferInfo(win.GetStdHandle(win.STD_OUTPUT_HANDLE), &info) {
		width = int(info.srWindow.Right - info.srWindow.Left) + 1
		height = int(info.srWindow.Bottom - info.srWindow.Top) + 1
		return width, height, width > 0
	}
	return
}
