package odinlings

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:terminal"
import "core:terminal/ansi"

BOLD      :: ansi.BOLD
UNDERLINE :: ansi.UNDERLINE
INVERT    :: ansi.INVERT
FG_RED    :: ansi.FG_RED
FG_GREEN  :: ansi.FG_GREEN
FG_YELLOW :: ansi.FG_YELLOW
FG_BLUE   :: ansi.FG_BLUE
FG_CYAN   :: ansi.FG_CYAN
FG_MAGENTA :: ansi.FG_MAGENTA

// Set by `-no-color`.
no_color_flag: bool

// Whether to print colours and other escape sequences.
ansi_enabled :: proc() -> bool {
	return !no_color_flag && terminal.color_enabled && !terminal.is_dumb && terminal.is_terminal(os.stdout)
}

// Whether to print file paths as clickable OSC 8 hyperlinks. VS Code's
// terminal detects paths on its own and handles the escape badly.
links_enabled :: proc() -> bool {
	if !ansi_enabled() {
		return false
	}
	buf: [64]u8
	term_program, _ := os.lookup_env(buf[:], "TERM_PROGRAM")
	return term_program != "vscode"
}

// Writes an SGR escape sequence with the given codes (if colours are on).
sgr :: proc(b: ^strings.Builder, codes: ..string) {
	if !ansi_enabled() || len(codes) == 0 {
		return
	}
	strings.write_string(b, ansi.CSI)
	for code, i in codes {
		if i > 0 {
			strings.write_byte(b, ';')
		}
		strings.write_string(b, code)
	}
	strings.write_string(b, ansi.SGR)
}

reset_style :: proc(b: ^strings.Builder) {
	sgr(b, ansi.RESET)
}

// Writes `text` with the given SGR codes, then resets the style.
styled :: proc(b: ^strings.Builder, text: string, codes: ..string) {
	sgr(b, ..codes)
	strings.write_string(b, text)
	if len(codes) > 0 {
		reset_style(b)
	}
}

// Clears the screen and the scrollback and moves the cursor home.
clear_screen :: proc(b: ^strings.Builder) {
	if terminal.is_dumb || !terminal.is_terminal(os.stdout) {
		return
	}
	strings.write_string(b, ansi.CSI + ansi.CUP)
	strings.write_string(b, ansi.CSI + "2" + ansi.ED)
	strings.write_string(b, ansi.CSI + "3" + ansi.ED)
}

clear_line :: proc(b: ^strings.Builder) {
	if ansi_enabled() {
		strings.write_string(b, ansi.CSI + ansi.EL)
	}
}

// Writes the builder to `f` and empties it.
flush :: proc(b: ^strings.Builder, f := os.stdout) {
	os.write_string(f, strings.to_string(b^))
	strings.builder_reset(b)
}

// `Progress: [#####>----------]  12/52`, fitted to `width` columns.
progress_bar :: proc(b: ^strings.Builder, done, total, width: int) {
	PREFIX     :: "Progress: ["
	POSTFIX_W  :: len("] xxx/xxx")
	WRAPPER_W  :: len(PREFIX) + POSTFIX_W
	MIN_WIDTH  :: WRAPPER_W + 4

	if width < MIN_WIDTH || total <= 0 {
		fmt.sbprintf(b, "Progress: %d/%d", done, total)
		return
	}

	bar := width - WRAPPER_W
	filled := bar * done / total

	strings.write_string(b, PREFIX)
	sgr(b, FG_GREEN)
	for _ in 0 ..< filled {
		strings.write_byte(b, '#')
	}
	if filled < bar {
		strings.write_byte(b, '>')
		sgr(b, FG_RED)
		for _ in 0 ..< bar - filled - 1 {
			strings.write_byte(b, '-')
		}
	}
	reset_style(b)
	// Odin pads integers with zeros, so pad the count with spaces by hand.
	count := fmt.tprint(done)
	strings.write_string(b, "] ")
	for _ in len(count) ..< 3 {
		strings.write_byte(b, ' ')
	}
	fmt.sbprintf(b, "%s/%d", count, total)
}

// Writes a path relative to the repository root, underlined and clickable in
// terminals that support OSC 8 hyperlinks.
file_link :: proc(b: ^strings.Builder, tool: ^Odin_Tool, rel_path: string, color := FG_BLUE) {
	if links_enabled() {
		abs := fmt.tprintf("%s/%s", tool.root, rel_path)
		when ODIN_OS == .Windows {
			abs, _ = strings.replace_all(abs, "\\", "/", context.temp_allocator)
			strings.write_string(b, ansi.OSC + "8;;file:///")
		} else {
			strings.write_string(b, ansi.OSC + "8;;file://")
		}
		strings.write_string(b, abs)
		strings.write_string(b, ansi.ST)
		styled(b, rel_path, UNDERLINE, color)
		strings.write_string(b, ansi.OSC + "8;;" + ansi.ST)
	} else {
		styled(b, rel_path, UNDERLINE, color)
	}
}

// Size of the terminal in columns and rows. Falls back to $COLUMNS/$LINES and
// then to 80x24.
term_size :: proc() -> (width, height: int) {
	if w, h, ok := _term_size(); ok {
		return w, h
	}
	width, height = 80, 24
	buf: [32]u8
	if s, err := os.lookup_env(buf[:], "COLUMNS"); err == nil {
		if n, ok := strconv.parse_int(s); ok && n > 0 {
			width = n
		}
	}
	if s, err := os.lookup_env(buf[:], "LINES"); err == nil {
		if n, ok := strconv.parse_int(s); ok && n > 0 {
			height = n
		}
	}
	return
}
