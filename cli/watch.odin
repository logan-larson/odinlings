package odinlings

import "core:fmt"
import "core:os"
import "core:strings"
import "core:time"

@(private = "file")
Watch_Event :: enum {
	None,
	Next,
	Run,
	Hint,
	List,
	Reset,
	Quit,
	File_Changed,
	Resize,
}

@(private = "file")
Watch_State :: struct {
	app:            ^App_State,
	output:         strings.Builder, // what the last check of the current exercise printed
	show_hint:      bool,
	done:           bool, // the last check of the current exercise passed
	manual_run:     bool,
	term_width:     int,
	watched:        int, // index of the exercise whose file time is tracked
	last_mtime:     time.Time,
	pending_change: bool,
	change_at:      time.Tick,
}

QUIT_MESSAGE :: `
We hope you're enjoying learning Odin!
If you want to continue working on the exercises at a later point, you can simply run 'odinlings' again in this directory.
`

// The interactive mode: checks the current exercise every time its file
// changes and reacts to single key presses.
watch :: proc(app: ^App_State, manual_run: bool) -> int {
	if !stdin_is_terminal() || !os.is_tty(os.stdout) {
		fmt.eprintln("Watch mode needs an interactive terminal.")
		fmt.eprintln("Use 'odinlings run' to check the current exercise once.")
		return 1
	}
	if !enable_raw_input() {
		fmt.eprintln("Could not switch the terminal to single-key input.")
		return 1
	}
	defer restore_input()

	ws := Watch_State {
		app        = app,
		output     = strings.builder_make(),
		manual_run = manual_run,
		watched    = -1,
	}
	defer strings.builder_destroy(&ws.output)
	ws.term_width, _ = term_size()

	run_current(&ws)
	for {
		free_all(context.temp_allocator)
		switch next_event(&ws) {
		case .None:
		case .Next:
			if !ws.done {
				break
			}
			switch done_current(app) {
			case .All_Done:
				return 0
			case .New_Pending:
				run_current(&ws)
			}
		case .Run, .File_Changed:
			run_current(&ws)
		case .Hint:
			ws.show_hint = true
			render(&ws)
		case .List:
			before := app.current
			list_view(app)
			if app.current != before {
				run_current(&ws)
			} else {
				render(&ws)
			}
		case .Reset:
			if confirm_reset(&ws) {
				run_current(&ws)
			} else {
				render(&ws)
			}
		case .Quit:
			os.write_string(os.stdout, "q\n")
			os.write_string(os.stdout, QUIT_MESSAGE)
			return 0
		case .Resize:
			render(&ws)
		}
	}
}

@(private = "file")
next_event :: proc(ws: ^Watch_State) -> Watch_Event {
	if ev, ok := read_key(POLL_INTERVAL_MS); ok {
		#partial switch ev.key {
		case .Ctrl_C:
			return .Quit
		case .Char:
			switch ev.ch {
			case 'n', 'N':
				return .Next
			case 'r', 'R':
				return .Run if ws.manual_run else .None
			case 'h', 'H':
				return .Hint
			case 'l', 'L':
				return .List
			case 'x', 'X':
				return .Reset
			case 'q', 'Q':
				return .Quit
			}
		}
		return .None
	}

	if !ws.manual_run {
		ex := current_exercise(ws.app)
		if mtime, err := os.modification_time_by_path(ex.path); err == nil {
			if ws.watched != ws.app.current {
				ws.watched = ws.app.current
				ws.last_mtime = mtime
				ws.pending_change = false
			} else if mtime != ws.last_mtime {
				ws.last_mtime = mtime
				ws.pending_change = true
				ws.change_at = time.tick_now()
			}
		}
		// Editors often write a file in several steps; wait until it settles.
		if ws.pending_change && time.tick_since(ws.change_at) >= DEBOUNCE {
			ws.pending_change = false
			return .File_Changed
		}
	}

	if w, _ := term_size(); w != ws.term_width {
		ws.term_width = w
		return .Resize
	}
	return .None
}

@(private = "file")
run_current :: proc(ws: ^Watch_State) {
	ex := current_exercise(ws.app)
	b := strings.builder_make(context.temp_allocator)
	strings.write_string(&b, "\nChecking the exercise `")
	strings.write_string(&b, ex.name)
	strings.write_string(&b, "`. Please wait…\n")
	flush(&b)

	// Remember the file time before checking so edits made during the check
	// trigger another one.
	if mtime, err := os.modification_time_by_path(ex.path); err == nil {
		ws.watched = ws.app.current
		ws.last_mtime = mtime
	}

	ws.show_hint = false
	ws.done = run_exercise(ws.app.tool, ex.info, &ws.output, {})
	if !ws.done {
		set_pending(ws.app, ws.app.current)
	}
	drain_input()
	render(ws)
}

@(private = "file")
render :: proc(ws: ^Watch_State) {
	app := ws.app
	ex := current_exercise(app)
	b := strings.builder_make(context.temp_allocator)

	strings.write_string(&b, "\n")
	clear_screen(&b)
	strings.write_string(&b, strings.to_string(ws.output))
	if !strings.has_suffix(strings.to_string(ws.output), "\n") {
		strings.write_string(&b, "\n")
	}

	if ws.show_hint {
		strings.write_string(&b, "\n")
		styled(&b, "Hint", BOLD, UNDERLINE, FG_CYAN)
		strings.write_string(&b, "\n")
		strings.write_string(&b, strings.trim_space(ex.hint))
		strings.write_string(&b, "\n")
	}

	if ws.done {
		strings.write_string(&b, "\n")
		styled(&b, "Exercise done ✓", BOLD, FG_GREEN)
		strings.write_string(&b, "\n")
		sol := solution_path(ex.info, context.temp_allocator)
		if os.exists(sol) {
			styled(&b, "Solution", BOLD)
			strings.write_string(&b, " for comparison: ")
			file_link(&b, app.tool, sol, FG_CYAN)
			strings.write_string(&b, "\n")
		}
		strings.write_string(&b, "When done experimenting, enter `n` to move on to the next exercise\n")
	}

	strings.write_string(&b, "\n")
	progress_bar(&b, app.n_done, len(app.exercises), ws.term_width)
	strings.write_string(&b, "\nCurrent exercise: ")
	file_link(&b, app.tool, ex.path)
	strings.write_string(&b, "\n\n")

	if ws.done {
		key_help(&b, "n", "next")
	}
	if ws.manual_run {
		key_help(&b, "r", "run")
	}
	if !ws.show_hint {
		key_help(&b, "h", "hint")
	}
	key_help(&b, "l", "list")
	key_help(&b, "x", "reset")
	key_help(&b, "q", "quit", last = true)
	strings.write_string(&b, " ? ")
	flush(&b)
}

@(private = "file")
key_help :: proc(b: ^strings.Builder, key, label: string, last := false) {
	styled(b, key, BOLD)
	strings.write_byte(b, ':')
	strings.write_string(b, label)
	if !last {
		strings.write_string(b, " / ")
	}
}

@(private = "file")
confirm_reset :: proc(ws: ^Watch_State) -> bool {
	app := ws.app
	b := strings.builder_make(context.temp_allocator)
	clear_screen(&b)
	strings.write_string(&b, "Resetting will undo all your changes to the file ")
	file_link(&b, app.tool, current_exercise(app).path)
	strings.write_string(&b, "\nReset (y/n)? ")
	flush(&b)

	for {
		ev := read_key(-1) or_continue
		if ev.key == .Ctrl_C {
			return false
		}
		if ev.key != .Char {
			continue
		}
		switch ev.ch {
		case 'y', 'Y':
			ok, msg := reset_exercise(app, app.current)
			if !ok {
				strings.builder_reset(&ws.output)
				styled(&ws.output, msg, BOLD, FG_RED)
				strings.write_string(&ws.output, "\n")
				ws.done = false
				return false
			}
			return true
		case 'n', 'N':
			return false
		}
	}
}
