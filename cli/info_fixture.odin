package odinlings

// A tiny table used by the CLI tests in `tests/`. Build the CLI with
// `-define:ODINLINGS_FIXTURE=true` to use it.
when ODINLINGS_FIXTURE {
	@(rodata)
	EXERCISES := []Exercise_Info {
		{name = "compilation_success", dir = "fixture", hint = `No hint.`},
		{name = "compilation_failure", dir = "fixture", hint = `No hint.`},
		{name = "test_success", dir = "fixture", mode = .Test, hint = `No hint.`},
		{name = "test_failure", dir = "fixture", mode = .Test, hint = `The answer to everything: 42`},
		{name = "output_mismatch", dir = "fixture", expected_output = `hello`, hint = `Print hello.`},
	}
}
