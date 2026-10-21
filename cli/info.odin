package odinlings

// How an exercise is checked.
Mode :: enum u8 {
	// `odin build` the exercise, then run it. It passes when it exits with
	// code 0 (and, if `expected_output` is set, prints exactly that).
	Run,
	// `odin test` the exercise. It passes when all `@(test)` procedures pass.
	Test,
}

// One row of the exercise table. The order of the table is the order of the
// course.
Exercise_Info :: struct {
	// Unique name: 1-32 characters of [A-Za-z0-9_]. The exercise lives in
	// `exercises/<dir>/<name>/<name>.odin`.
	name:                string,
	// Topic directory, e.g. "01_variables" or "quizzes".
	dir:                 string,
	mode:                Mode,
	// Shown when the learner presses `h` or runs `odinlings hint`.
	hint:                string,
	// Optional, `.Run` only. The program's output must equal this after
	// trailing whitespace is removed from every line and from the end.
	expected_output:     string,
	// Check the exercise with the strict flags used for solutions.
	strict:              bool,
	// `dev check` normally requires that an unsolved exercise fails. Set this
	// for exercises that already pass (like the first one).
	skip_check_unsolved: bool,
	// `.Test` only. Fail the tests when memory is leaked or freed badly.
	track_memory:        bool,
}

WELCOME_MESSAGE :: `Welcome to Odinlings!

Odinlings teaches you the Odin programming language by handing you small
programs that are broken and asking you to fix them. A few things to know:

1. Every exercise lives in its own directory under 'exercises/'. It either
   does not compile, does not run cleanly, or does not pass its tests yet.
   Read the comments at the top of the file and look for the 'TODO' markers.

2. Keep your editor open in this directory. Odinlings shows the path of the
   current exercise under the progress bar. Every time you save the file,
   Odinlings checks it again. Once it passes, press 'n' to move on.

3. Stuck? Press 'h' to see a hint. After you finish an exercise, Odinlings
   also points you to a reference solution under 'solutions/'.

4. Found a mistake, or is something unclear? Please open an issue on GitHub.`

FINAL_MESSAGE :: `You finished every exercise. Well done!

You now know your way around the core of Odin. Some places to go next:

  - The language overview:  https://odin-lang.org/docs/overview/
  - The core library docs:  https://pkg.odin-lang.org/
  - Example programs:       https://github.com/odin-lang/examples
  - The Odin community:     https://odin-lang.org/community/

If you found a mistake or want to add an exercise, see CONTRIBUTING.md.`
