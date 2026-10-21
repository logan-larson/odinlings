package odinlings

// The course. The order of this table is the order in which exercises are
// presented. Hints are raw strings, so they cannot contain backticks; use
// 'single quotes' around code instead.
when !ODINLINGS_FIXTURE {
	@(rodata)
	EXERCISES := []Exercise_Info {
		// ------------------------------------------------------------ 00_intro
		{
			name = "intro1",
			dir = "00_intro",
			skip_check_unsolved = true,
			hint = `
There is nothing to fix here. Press 'n' to move on to the next exercise.`,
		},
		{
			name = "intro2",
			dir = "00_intro",
			expected_output = `Hellope, Odinlings!`,
			hint = `
The compiler says that 'fmt' is undeclared. Procedures from Odin's core
library live in packages, and a package has to be imported at the top of the
file before you can use it:

    import "core:fmt"`,
		},
	}
}
