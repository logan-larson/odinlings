// Tests for the odinlings command line tool.
//
// They run a build of the CLI that uses the small fixture table from
// `cli/info_fixture.odin` against the exercises in `tests/fixture/`. Run them
// from the repository root:
//
//     odin build cli -out:tests/odinlings-fixture -define:ODINLINGS_FIXTURE=true
//     odin test tests/cli -define:ODIN_TEST_THREADS=1
//
// The tests share the fixture's state file, so they must not run in parallel.
package cli_test

import "core:fmt"
import "core:os"
import "core:strings"
import "core:testing"

EXE_EXT :: ".exe" when ODIN_OS == .Windows else ""

@(private = "file")
Result :: struct {
	exit_code: int,
	output:    string, // stdout followed by stderr
}

// Runs the fixture CLI in `tests/fixture` with a fresh state file.
@(private = "file")
odinlings :: proc(t: ^testing.T, args: ..string) -> Result {
	cwd, cwd_err := os.get_working_directory(context.temp_allocator)
	testing.expect(t, cwd_err == nil)
	bin := fmt.tprintf("%s/tests/odinlings-fixture%s", cwd, EXE_EXT)
	fixture := fmt.tprintf("%s/tests/fixture", cwd)
	if !os.exists(bin) {
		testing.fail_now(t, "tests/odinlings-fixture is missing; build it first (see the comment at the top of this file)")
	}
	_ = os.remove(fmt.tprintf("%s/.odinlings-state.txt", fixture))

	command := make([dynamic]string, context.temp_allocator)
	append(&command, bin, "-no-color")
	append(&command, ..args)
	state, stdout, stderr, err := os.process_exec({command = command[:], working_dir = fixture}, context.temp_allocator)
	testing.expectf(t, err == nil, "could not run %s: %v", bin, err)
	return {exit_code = state.exit_code, output = strings.concatenate({string(stdout), string(stderr)}, context.temp_allocator)}
}

@(private = "file")
expect_output :: proc(t: ^testing.T, r: Result, want: string, loc := #caller_location) {
	testing.expectf(t, strings.contains(r.output, want), "expected the output to contain %q, got:\n%s", want, r.output, loc = loc)
}

@(test)
run_compilation_success :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "compilation_success")
	testing.expect_value(t, r.exit_code, 0)
	expect_output(t, r, "Output from the `main` procedure")
	expect_output(t, r, "Successfully ran")
	expect_output(t, r, "Next exercise: exercises/fixture/compilation_failure/compilation_failure.odin")
}

@(test)
run_compilation_failure :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "compilation_failure")
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "Syntax Error")
	expect_output(t, r, "with errors")
}

@(test)
run_test_success :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "test_success")
	testing.expect_value(t, r.exit_code, 0)
	expect_output(t, r, "All tests passed")
}

@(test)
run_test_failure :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "test_failure")
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "expected 6 * 9 to be 42, got 54")
}

@(test)
run_output_mismatch :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "output_mismatch")
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "Expected this output:\nhello\n\nBut found:\ngoodbye")
}

@(test)
run_exercise_not_in_table :: proc(t: ^testing.T) {
	r := odinlings(t, "run", "not_in_table")
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "No exercise found for 'not_in_table'!")
}

@(test)
hint_shows_the_hint :: proc(t: ^testing.T) {
	r := odinlings(t, "hint", "test_failure")
	testing.expect_value(t, r.exit_code, 0)
	expect_output(t, r, "Hint:\nThe answer to everything: 42")
}

@(test)
reset_needs_a_name :: proc(t: ^testing.T) {
	r := odinlings(t, "reset")
	testing.expect_value(t, r.exit_code, 2)
}

@(test)
unknown_command :: proc(t: ^testing.T) {
	r := odinlings(t, "frobnicate")
	testing.expect_value(t, r.exit_code, 2)
	expect_output(t, r, "Unknown command 'frobnicate'")
}

@(test)
list_shows_every_exercise :: proc(t: ^testing.T) {
	r := odinlings(t, "list")
	testing.expect_value(t, r.exit_code, 0)
	for name in ([]string{"compilation_success", "compilation_failure", "test_success", "test_failure", "output_mismatch"}) {
		expect_output(t, r, name)
	}
}

@(test)
check_all_reports_pending :: proc(t: ^testing.T) {
	r := odinlings(t, "check-all")
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "3/5 exercises pending")
}

@(test)
first_run_shows_the_welcome_message :: proc(t: ^testing.T) {
	r := odinlings(t, "hint")
	expect_output(t, r, "Welcome to Odinlings!")
}

@(test)
watch_mode_needs_a_terminal :: proc(t: ^testing.T) {
	r := odinlings(t)
	testing.expect_value(t, r.exit_code, 1)
	expect_output(t, r, "Watch mode needs an interactive terminal")
}
