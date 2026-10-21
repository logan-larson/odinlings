package odinlings

import "core:fmt"
import "core:os"
import "core:strings"

Exercise :: struct {
	using info: Exercise_Info,
	path:       string, // exercises/<dir>/<name>/<name>.odin, shown to the learner
	done:       bool,
}

Run_Options :: struct {
	strict:       bool, // add the strict vet/style flags
	use_solution: bool, // check solutions/... instead of exercises/...
}

// Flags used for every exercise. `-vet-unused` turns unused variables and
// imports into errors, which Odin otherwise allows.
@(rodata)
COMMON_FLAGS := [?]string{"-o:none", "-vet-unused", "-warnings-as-errors", "-error-pos-style:unix"}

// Added for solutions and `strict` exercises.
@(rodata)
STRICT_FLAGS := [?]string{"-vet", "-vet-tabs", "-vet-style", "-strict-style", "-disallow-do"}

// Keep the test runner's output short and predictable.
@(rodata)
TEST_FLAGS := [?]string{
	"-define:ODIN_TEST_FANCY=false",
	"-define:ODIN_TEST_SHORT_LOGS=true",
	"-define:ODIN_TEST_LOG_LEVEL=warning",
	"-define:ODIN_TEST_THREADS=1",
}

exercise_dir :: proc(info: Exercise_Info, allocator := context.allocator) -> string {
	return fmt.aprintf("exercises/%s/%s", info.dir, info.name, allocator = allocator)
}

exercise_path :: proc(info: Exercise_Info, allocator := context.allocator) -> string {
	return fmt.aprintf("exercises/%s/%s/%s.odin", info.dir, info.name, info.name, allocator = allocator)
}

solution_dir :: proc(info: Exercise_Info, allocator := context.allocator) -> string {
	return fmt.aprintf("solutions/%s/%s", info.dir, info.name, allocator = allocator)
}

solution_path :: proc(info: Exercise_Info, allocator := context.allocator) -> string {
	return fmt.aprintf("solutions/%s/%s/%s.odin", info.dir, info.name, info.name, allocator = allocator)
}

// Every exercise (and solution) gets its own output file so that parallel
// checks never write to the same path.
build_output_path :: proc(tool: ^Odin_Tool, info: Exercise_Info, use_solution: bool, allocator := context.allocator) -> string {
	suffix := "_sol" if use_solution else ""
	return fmt.aprintf("%s/%s/%s%s%s", tool.root, BUILD_DIR, info.name, suffix, EXE_EXT, allocator = allocator)
}

// Builds and runs (or tests) an exercise. Everything the compiler and the
// program print goes into `output`, followed by odinlings' own notes about
// what went wrong. Returns whether the exercise passes.
run_exercise :: proc(tool: ^Odin_Tool, info: Exercise_Info, output: ^strings.Builder, opts: Run_Options) -> bool {
	strings.builder_reset(output)

	dir := solution_dir(info, context.temp_allocator) if opts.use_solution else exercise_dir(info, context.temp_allocator)
	out_path := build_output_path(tool, info, opts.use_solution, context.temp_allocator)

	cmd := make([dynamic]string, context.temp_allocator)
	append(&cmd, tool.exe, "test" if info.mode == .Test else "build", dir)
	append(&cmd, fmt.tprintf("-out:%s", out_path))
	append(&cmd, ..COMMON_FLAGS[:])
	if opts.strict || info.strict {
		append(&cmd, ..STRICT_FLAGS[:])
	}
	if info.mode == .Test {
		append(&cmd, ..TEST_FLAGS[:])
		// Memory tracking stays on (the default). Turning it off leaves an
		// unused import in core:testing, which `-vet-unused` rejects.
		if info.track_memory {
			append(&cmd, "-define:ODIN_TEST_FAIL_ON_BAD_MEMORY=true")
		}
	}

	res, err := run_cmd(cmd[:], "", output, COMPILE_TIMEOUT)
	shorten_paths(output, tool.root)
	if err != nil {
		write_failure(output, fmt.tprintf("Could not run the Odin compiler: %s", os.error_string(err)))
		return false
	}
	if res.timed_out {
		write_failure(output, fmt.tprintf("The Odin compiler did not finish within %v.", COMPILE_TIMEOUT))
		return false
	}

	if info.mode == .Test {
		if res.exit_code != 0 {
			return false
		}
		strings.builder_reset(output)
		styled(output, "All tests passed", BOLD, FG_GREEN)
		strings.write_string(output, "\n")
		return true
	}

	if res.exit_code != 0 {
		return false
	}

	// The build succeeded; the compiler had nothing interesting to say.
	strings.builder_reset(output)
	styled(output, "Output", UNDERLINE)
	strings.write_string(output, "\n")

	program_output := strings.builder_make(context.temp_allocator)
	run_res, run_err := run_cmd({out_path}, dir, &program_output, RUN_TIMEOUT)
	strings.write_string(output, strings.to_string(program_output))

	if run_err != nil {
		write_failure(output, fmt.tprintf("Could not start the exercise: %s", os.error_string(run_err)))
		return false
	}
	if run_res.timed_out {
		write_failure(output, fmt.tprintf("The exercise did not finish within %v. Is there an endless loop?", RUN_TIMEOUT))
		return false
	}
	if run_res.exit_code != 0 {
		write_failure(output, "The exercise didn't run successfully (nonzero exit code)")
		return false
	}

	if info.expected_output != "" {
		actual := normalize_output(strings.to_string(program_output), context.temp_allocator)
		expected := normalize_output(info.expected_output, context.temp_allocator)
		if actual != expected {
			strings.write_string(output, "\n")
			styled(output, "The output is not what the exercise expects.", BOLD, FG_RED)
			strings.write_string(output, "\n\n")
			styled(output, "Expected this output:", UNDERLINE)
			strings.write_string(output, "\n")
			strings.write_string(output, expected)
			strings.write_string(output, "\n\n")
			styled(output, "But found:", UNDERLINE)
			strings.write_string(output, "\n")
			strings.write_string(output, actual)
			strings.write_string(output, "\n")
			return false
		}
	}
	return true
}

// The compiler prints absolute paths; show them relative to the repository.
@(private = "file")
shorten_paths :: proc(output: ^strings.Builder, root: string) {
	prefix := fmt.tprintf("%s/", root)
	text := strings.to_string(output^)
	if !strings.contains(text, prefix) {
		return
	}
	shortened, _ := strings.replace_all(text, prefix, "", context.temp_allocator)
	strings.builder_reset(output)
	strings.write_string(output, shortened)
}

@(private = "file")
write_failure :: proc(output: ^strings.Builder, msg: string) {
	strings.write_string(output, "\n")
	styled(output, msg, BOLD, FG_RED)
	strings.write_string(output, "\n")
}

// Normalizes program output for comparison: Windows line endings become "\n",
// trailing whitespace is removed from every line, and trailing empty lines are
// dropped.
normalize_output :: proc(s: string, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	rest := s
	first := true
	for line in strings.split_lines_iterator(&rest) {
		if !first {
			strings.write_byte(&b, '\n')
		}
		first = false
		strings.write_string(&b, strings.trim_right_space(line))
	}
	return strings.trim_right_space(strings.to_string(b))
}
