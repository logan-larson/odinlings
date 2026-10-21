package odinlings

import "core:fmt"
import "core:os"
import "core:strings"

App_State :: struct {
	tool:      ^Odin_Tool,
	exercises: []Exercise,
	current:   int,
	n_done:    int,
}

State_File_Status :: enum {
	Read,
	Not_Read, // missing or unreadable: show the welcome message
}

Progress :: enum {
	All_Done,
	New_Pending,
}

STATE_FILE_HEADER :: "DON'T EDIT THIS FILE!\n\n"

app_state_init :: proc(tool: ^Odin_Tool) -> (app: ^App_State, status: State_File_Status) {
	app = new(App_State)
	app.tool = tool
	app.exercises = make([]Exercise, len(EXERCISES))
	for info, i in EXERCISES {
		app.exercises[i] = Exercise {
			info = info,
			path = exercise_path(info),
		}
	}

	status = .Not_Read
	data, err := os.read_entire_file(STATE_FILE, context.temp_allocator)
	if err != nil {
		return
	}

	// Format:
	//   DON'T EDIT THIS FILE!
	//   <empty line>
	//   <current exercise name>
	//   <empty line>
	//   <done exercise name>...
	text := string(data)
	lines := strings.split_lines(text, context.temp_allocator)
	if len(lines) < 4 || lines[2] == "" {
		return
	}

	if idx, found := find_exercise(app, lines[2]); found {
		app.current = idx
	}
	for line in lines[4:] {
		if line == "" {
			break
		}
		if idx, found := find_exercise(app, line); found && !app.exercises[idx].done {
			app.exercises[idx].done = true
			app.n_done += 1
		}
	}
	status = .Read
	return
}

find_exercise :: proc(app: ^App_State, name: string) -> (idx: int, found: bool) {
	for ex, i in app.exercises {
		if ex.name == name {
			return i, true
		}
	}
	return -1, false
}

app_state_write :: proc(app: ^App_State) {
	b := strings.builder_make(context.temp_allocator)
	strings.write_string(&b, STATE_FILE_HEADER)
	strings.write_string(&b, app.exercises[app.current].name)
	strings.write_string(&b, "\n\n")
	for ex in app.exercises {
		if ex.done {
			strings.write_string(&b, ex.name)
			strings.write_byte(&b, '\n')
		}
	}
	if err := os.write_entire_file(STATE_FILE, strings.to_string(b)); err != nil {
		fmt.eprintfln("Failed to write %s: %s", STATE_FILE, os.error_string(err))
	}
}

current_exercise :: proc(app: ^App_State) -> ^Exercise {
	return &app.exercises[app.current]
}

set_current :: proc(app: ^App_State, idx: int) {
	if app.current == idx {
		return
	}
	app.current = idx
	app_state_write(app)
}

// Makes the named exercise the current one. Prints an error if there is no
// such exercise.
set_current_by_name :: proc(app: ^App_State, name: string) -> bool {
	idx, found := find_exercise(app, name)
	if !found {
		fmt.eprintfln("No exercise found for '%s'!", name)
		return false
	}
	set_current(app, idx)
	return true
}

// Sets the done flag without writing the state file. Returns whether it changed.
set_status :: proc(app: ^App_State, idx: int, done: bool) -> bool {
	ex := &app.exercises[idx]
	if ex.done == done {
		return false
	}
	ex.done = done
	app.n_done += 1 if done else -1
	return true
}

set_pending :: proc(app: ^App_State, idx: int) {
	if set_status(app, idx, false) {
		app_state_write(app)
	}
}

// The first pending exercise after the current one, wrapping around to the
// start of the course.
next_pending_index :: proc(app: ^App_State) -> (idx: int, found: bool) {
	n := len(app.exercises)
	for i in 1 ..= n {
		j := (app.current + i) % n
		if !app.exercises[j].done {
			return j, true
		}
	}
	return -1, false
}

first_pending_index :: proc(app: ^App_State) -> (idx: int, found: bool) {
	for ex, i in app.exercises {
		if !ex.done {
			return i, true
		}
	}
	return -1, false
}

// Marks the current exercise as done and moves on to the next pending one.
// When nothing is pending any more, every exercise is checked once more to
// make sure. If all of them pass, the final message is printed.
done_current :: proc(app: ^App_State) -> Progress {
	set_status(app, app.current, true)
	if idx, found := next_pending_index(app); found {
		app.current = idx
		app_state_write(app)
		return .New_Pending
	}
	app_state_write(app)

	if first, all_done := check_all(app); !all_done {
		set_current(app, first)
		return .New_Pending
	}
	print_final_message(app)
	return .All_Done
}

// Runs every exercise and updates the done flags. Returns the first pending
// exercise, if any.
check_all :: proc(app: ^App_State) -> (first_pending: int, all_done: bool) {
	b := strings.builder_make(context.temp_allocator)
	clear_screen(&b)
	strings.write_string(&b, "Checking all exercises…\n")
	flush(&b)

	jobs := make([]Run_Job, len(app.exercises), context.temp_allocator)
	for ex, i in app.exercises {
		jobs[i] = Run_Job{idx = i, info = ex.info}
	}

	Check_Ctx :: struct {
		app:      ^App_State,
		finished: int,
	}
	ctx := Check_Ctx{app = app}
	results := run_many(app.tool, jobs, proc(data: rawptr, d: Run_Done) {
		ctx := (^Check_Ctx)(data)
		ctx.finished += 1
		ex := ctx.app.exercises[d.idx]
		b := strings.builder_make(context.temp_allocator)
		tty := os.is_tty(os.stdout)
		if tty {
			strings.write_string(&b, "\r")
		}
		if d.success {
			styled(&b, "   DONE", FG_GREEN)
		} else {
			styled(&b, "PENDING", FG_RED)
		}
		strings.write_string(&b, " ")
		strings.write_string(&b, ex.name)
		clear_line(&b)
		strings.write_string(&b, "\n")
		if tty {
			fmt.sbprintf(&b, "Progress: %d/%d", ctx.finished, len(ctx.app.exercises))
		}
		flush(&b)
	}, &ctx)
	if os.is_tty(os.stdout) {
		strings.write_string(&b, "\n")
		flush(&b)
	}

	for r in results {
		set_status(app, r.idx, r.success)
	}
	app_state_write(app)

	first, found := first_pending_index(app)
	return first, !found
}

// Restores an exercise file with `git checkout` and marks it as pending.
reset_exercise :: proc(app: ^App_State, idx: int) -> (ok: bool, msg: string) {
	set_pending(app, idx)
	path := app.exercises[idx].path
	out := strings.builder_make(context.temp_allocator)
	res, err := run_cmd({"git", "checkout", "--", path}, "", &out, COMPILE_TIMEOUT)
	if err != nil || !res.exited || res.exit_code != 0 {
		details := strings.trim_space(strings.to_string(out))
		if err != nil {
			details = os.error_string(err)
		}
		return false, fmt.tprintf(
			"Could not reset %s with git (%s).\nOdinlings expects to run inside a git clone of the repository; restore the file manually.",
			path,
			details,
		)
	}
	return true, ""
}

print_final_message :: proc(app: ^App_State) {
	b := strings.builder_make(context.temp_allocator)
	clear_screen(&b)
	sgr(&b, BOLD, FG_GREEN)
	strings.write_string(&b, FINISH_BANNER)
	reset_style(&b)
	strings.write_string(&b, "\n")
	strings.write_string(&b, FINAL_MESSAGE)
	strings.write_string(&b, "\n")
	flush(&b)
}

FINISH_BANNER :: `
  +--------------------------------------------------+
  |                                                  |
  |     You made it all the way through Odinlings!   |
  |                                                  |
  +--------------------------------------------------+
`
