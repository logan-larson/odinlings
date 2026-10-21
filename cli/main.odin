package odinlings

import "core:fmt"
import "core:os"
import "core:strings"

USAGE :: `odinlings: small exercises to get you used to reading and writing Odin code

Usage:
  odinlings [-manual-run] [-no-color]   Start watch mode (the default)
  odinlings run [NAME]                  Check an exercise once (default: the current one)
  odinlings hint [NAME]                 Show the hint of an exercise (default: the current one)
  odinlings reset NAME                  Undo your changes to an exercise (uses git)
  odinlings check-all                   Check every exercise and update your progress
  odinlings list                        List all exercises and their state
  odinlings dev check                   Validate the exercises and solutions (for contributors)
  odinlings help                        Show this message
  odinlings version                     Show the odinlings version

Options:
  -manual-run   Don't watch the exercise file; press 'r' in watch mode to check it
  -no-color     Don't print colours or clickable links (NO_COLOR is honoured too)

Run odinlings from the root of the odinlings repository.
`

main :: proc() {
	os.exit(run_main(os.args[1:]))
}

run_main :: proc(raw_args: []string) -> int {
	// Global options may appear anywhere.
	args := make([dynamic]string)
	manual_run := false
	for arg in raw_args {
		switch arg {
		case "-manual-run", "--manual-run":
			manual_run = true
		case "-no-color", "--no-color":
			no_color_flag = true
		case:
			append(&args, arg)
		}
	}

	command := args[0] if len(args) > 0 else ""
	rest := args[1:] if len(args) > 0 else args[:]

	switch command {
	case "help", "-h", "-help", "--help":
		os.write_string(os.stdout, USAGE)
		return 0
	case "version", "-version", "--version":
		fmt.println("odinlings", VERSION)
		return 0
	case "", "watch", "run", "hint", "reset", "check-all", "list", "dev":
	case:
		fmt.eprintfln("Unknown command '%s'.\n", command)
		os.write_string(os.stderr, USAGE)
		return 2
	}

	if command == "reset" && len(rest) != 1 {
		fmt.eprintln("Usage: odinlings reset NAME")
		return 2
	}
	if command == "dev" && (len(rest) != 1 || rest[0] != "check") {
		fmt.eprintln("Usage: odinlings dev check")
		return 2
	}
	if (command == "run" || command == "hint") && len(rest) > 1 {
		fmt.eprintfln("Usage: odinlings %s [NAME]", command)
		return 2
	}
	if command != "dev" && command != "reset" && command != "run" && command != "hint" && len(rest) > 0 {
		fmt.eprintfln("Unexpected argument '%s'.", rest[0])
		return 2
	}

	if !os.is_directory("exercises") {
		fmt.eprintln("Could not find the 'exercises/' directory.")
		fmt.eprintln("Run odinlings from the root of the odinlings repository.")
		return 1
	}

	tool: Odin_Tool
	ok: bool
	if tool, ok = odin_tool_init(); !ok {
		return 1
	}
	if err := os.make_directory_all(BUILD_DIR); err != nil && !os.is_directory(BUILD_DIR) {
		fmt.eprintfln("Could not create %s: %s", BUILD_DIR, os.error_string(err))
		return 1
	}

	app, status := app_state_init(&tool)
	if status == .Not_Read && command != "dev" {
		show_welcome()
	}

	switch command {
	case "", "watch":
		return watch(app, manual_run)
	case "run":
		return cmd_run(app, rest[0] if len(rest) == 1 else "")
	case "hint":
		return cmd_hint(app, rest[0] if len(rest) == 1 else "")
	case "reset":
		return cmd_reset(app, rest[0])
	case "check-all":
		return cmd_check_all(app)
	case "list":
		print_exercise_table(app)
		return 0
	case "dev":
		return 0 if dev_check(app) else 1
	}
	return 0
}

// Shown the first time odinlings runs (when there is no state file yet).
show_welcome :: proc() {
	b := strings.builder_make(context.temp_allocator)
	interactive := stdin_is_terminal() && os.is_tty(os.stdout)
	if interactive {
		clear_screen(&b)
	}
	strings.write_string(&b, WELCOME_MESSAGE)
	strings.write_string(&b, "\n\n")
	if !interactive {
		flush(&b)
		return
	}
	strings.write_string(&b, "Press ENTER to continue ")
	flush(&b)
	buf: [256]byte
	for {
		n, err := os.read(os.stdin, buf[:])
		if err != nil || n <= 0 || strings.contains(string(buf[:n]), "\n") {
			break
		}
	}
	clear_screen(&b)
	flush(&b)
}

cmd_run :: proc(app: ^App_State, name: string) -> int {
	if name != "" && !set_current_by_name(app, name) {
		return 1
	}
	ex := current_exercise(app)
	b := strings.builder_make(context.temp_allocator)
	output := strings.builder_make(context.temp_allocator)
	success := run_exercise(app.tool, ex.info, &output, {})
	strings.write_string(&b, strings.to_string(output))
	strings.write_string(&b, "\n")

	if !success {
		set_pending(app, app.current)
		strings.write_string(&b, "Ran ")
		file_link(&b, app.tool, ex.path)
		strings.write_string(&b, " with errors\n")
		flush(&b)
		return 1
	}

	styled(&b, "✓ Successfully ran ", FG_GREEN)
	file_link(&b, app.tool, ex.path)
	strings.write_string(&b, "\n")
	sol := solution_path(ex.info, context.temp_allocator)
	if os.exists(sol) {
		styled(&b, "Solution", BOLD)
		strings.write_string(&b, " for comparison: ")
		file_link(&b, app.tool, sol, FG_CYAN)
		strings.write_string(&b, "\n")
	}
	flush(&b)

	switch done_current(app) {
	case .New_Pending:
		strings.write_string(&b, "\nNext exercise: ")
		file_link(&b, app.tool, current_exercise(app).path)
		strings.write_string(&b, "\n")
		flush(&b)
	case .All_Done:
	}
	return 0
}

cmd_hint :: proc(app: ^App_State, name: string) -> int {
	if name != "" && !set_current_by_name(app, name) {
		return 1
	}
	ex := current_exercise(app)
	b := strings.builder_make(context.temp_allocator)
	strings.write_string(&b, "Current exercise: ")
	file_link(&b, app.tool, ex.path)
	strings.write_string(&b, "\n\n")
	styled(&b, "Hint:", BOLD, FG_CYAN)
	strings.write_string(&b, "\n")
	strings.write_string(&b, strings.trim_space(ex.hint))
	strings.write_string(&b, "\n")
	flush(&b)
	return 0
}

cmd_reset :: proc(app: ^App_State, name: string) -> int {
	if !set_current_by_name(app, name) {
		return 1
	}
	ok, msg := reset_exercise(app, app.current)
	if !ok {
		fmt.eprintln(msg)
		return 1
	}
	b := strings.builder_make(context.temp_allocator)
	strings.write_string(&b, "The exercise ")
	file_link(&b, app.tool, current_exercise(app).path)
	strings.write_string(&b, " has been reset\n")
	flush(&b)
	return 0
}

cmd_check_all :: proc(app: ^App_State) -> int {
	first, all_done := check_all(app)
	if all_done {
		print_final_message(app)
		return 0
	}
	if app.exercises[app.current].done {
		set_current(app, first)
	}
	pending := len(app.exercises) - app.n_done
	b := strings.builder_make(context.temp_allocator)
	if pending == 1 {
		strings.write_string(&b, "\nOne exercise pending: ")
	} else {
		fmt.sbprintf(&b, "\n%d/%d exercises pending. The first: ", pending, len(app.exercises))
	}
	file_link(&b, app.tool, app.exercises[first].path)
	strings.write_string(&b, "\n")
	flush(&b)
	return 1
}
