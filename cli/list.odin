package odinlings

import "core:fmt"
import "core:strings"
import "core:terminal/ansi"

// Prints every exercise with its state. Used by `odinlings list`.
print_exercise_table :: proc(app: ^App_State) {
	b := strings.builder_make(context.temp_allocator)
	name_w := max_name_width(app)
	fmt.sbprintf(&b, "  Current  State    %-*s  Path\n", name_w, "Name")
	for _, i in app.exercises {
		write_row(&b, app, i, name_w)
		strings.write_string(&b, "\n")
	}
	strings.write_string(&b, "\n")
	progress_bar(&b, app.n_done, len(app.exercises), 0)
	strings.write_string(&b, "\n")
	flush(&b)
}

@(private = "file")
max_name_width :: proc(app: ^App_State) -> int {
	w := len("Name")
	for ex in app.exercises {
		w = max(w, len(ex.name))
	}
	return w
}

@(private = "file")
write_row :: proc(b: ^strings.Builder, app: ^App_State, i, name_w: int) {
	ex := app.exercises[i]
	strings.write_string(b, "  ")
	if i == app.current {
		styled(b, ">>>>>>>", FG_RED)
		strings.write_string(b, "  ")
	} else {
		strings.write_string(b, "         ")
	}
	if ex.done {
		styled(b, "DONE   ", FG_GREEN)
	} else {
		styled(b, "PENDING", FG_YELLOW)
	}
	fmt.sbprintf(b, "  %-*s  ", name_w, ex.name)
	strings.write_string(b, ex.path)
}

// The interactive list opened with `l` in watch mode. Returns when the
// learner presses `q` or picks an exercise with Enter/`c`.
list_view :: proc(app: ^App_State) {
	b := strings.builder_make(context.temp_allocator)
	strings.write_string(&b, ansi.CSI + ansi.DECASB_ENTER)
	strings.write_string(&b, ansi.CSI + ansi.DECTCEM_HIDE)
	flush(&b)
	defer {
		strings.write_string(&b, ansi.CSI + ansi.DECTCEM_SHOW)
		strings.write_string(&b, ansi.CSI + ansi.DECASB_EXIT)
		flush(&b)
	}

	selected := app.current
	offset := 0
	message := ""
	name_w := max_name_width(app)

	for {
		width, height := term_size()
		// Header line + footer (blank, progress, 2 help lines).
		rows := max(height - 5, 1)
		if selected < offset {
			offset = selected
		} else if selected >= offset + rows {
			offset = selected - rows + 1
		}

		strings.write_string(&b, ansi.CSI + ansi.CUP)
		strings.write_string(&b, ansi.CSI + "2" + ansi.ED)
		sgr(&b, BOLD)
		fmt.sbprintf(&b, "  Current  State    %-*s  Path", name_w, "Name")
		reset_style(&b)
		strings.write_string(&b, "\r\n")
		for i in offset ..< min(offset + rows, len(app.exercises)) {
			row := strings.builder_make(context.temp_allocator)
			write_row(&row, app, i, name_w)
			if i == selected {
				sgr(&b, INVERT)
				strings.write_string(&b, strings.to_string(row))
				reset_style(&b)
			} else {
				strings.write_string(&b, strings.to_string(row))
			}
			strings.write_string(&b, "\r\n")
		}
		strings.write_string(&b, "\r\n")
		progress_bar(&b, app.n_done, len(app.exercises), width)
		strings.write_string(&b, "\r\n")
		if message != "" {
			styled(&b, message, FG_MAGENTA)
			strings.write_string(&b, "\r\n")
		} else {
			strings.write_string(&b, "↓/j ↑/k: move  g/G: first/last  ")
			strings.write_string(&b, "Enter/c: continue at the selected exercise\r\n")
		}
		strings.write_string(&b, "r: reset the selected exercise  q: back to the current exercise")
		flush(&b)
		message = ""

		ev := read_key(-1) or_continue
		#partial switch ev.key {
		case .Up:
			selected = max(selected - 1, 0)
		case .Down:
			selected = min(selected + 1, len(app.exercises) - 1)
		case .Enter:
			set_current(app, selected)
			return
		case .Ctrl_C, .Escape:
			return
		case .Char:
			switch ev.ch {
			case 'k':
				selected = max(selected - 1, 0)
			case 'j':
				selected = min(selected + 1, len(app.exercises) - 1)
			case 'g':
				selected = 0
			case 'G':
				selected = len(app.exercises) - 1
			case 'c':
				set_current(app, selected)
				return
			case 'q':
				return
			case 'r':
				ok, msg := reset_exercise(app, selected)
				if ok {
					message = fmt.tprintf("The exercise `%s` has been reset", app.exercises[selected].name)
				} else {
					message = msg
				}
			}
		}
	}
}
