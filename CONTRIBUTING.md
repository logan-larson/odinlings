# Contributing to Odinlings

Thank you for helping! Odinlings is meant for people who are new to Odin, so the
most valuable contributions are often small: a clearer comment, a better hint, a
fix for an exercise that broke with a new Odin release.

Please open an issue before starting on anything bigger, like a new topic, so we
can agree on the plan first.

## Repository layout

| Path | Contents |
| --- | --- |
| `cli/` | The `odinlings` command line tool (package `odinlings`) |
| `cli/info_exercises.odin` | The table of exercises: order, hints, expected output |
| `exercises/<topic>/<name>/<name>.odin` | The exercises, one package directory each |
| `exercises/<topic>/README.md` | A short introduction to each topic with links |
| `solutions/<topic>/<name>/<name>.odin` | A reference solution for every exercise |
| `tests/` | Tests for the CLI itself (see `tests/README.md`) |

## Adding an exercise

1. Create `exercises/<topic>/<name>/<name>.odin`. Names may only use
   `[A-Za-z0-9_]` and are at most 32 characters long. A new topic directory needs
   a `README.md` with a `# Title`, a short explanation and a
   `## Further information` section with links.
2. Start the file with a comment that teaches the concept in a few lines, with a
   small code example. Put `package main` and a `main :: proc()` in every file.
3. Mark what the learner has to change with `// TODO:` comments.
4. Pick how the exercise is checked:
   - **Run** exercises are built and run. They pass when they exit with code 0 and,
     if `expected_output` is set, print exactly that text (trailing whitespace is
     ignored).
   - **Test** exercises are checked with `odin test`. Put the tests at the bottom
     under a `// Don't change the tests!` comment, and leave `main` empty with a
     `// You can optionally experiment here.` comment.
5. Add `solutions/<topic>/<name>/<name>.odin`: the same file, solved, with short
   comments that explain the solution.
6. Add a row to the table in `cli/info_exercises.odin`, at the place in the course
   where it belongs. The `hint` should be enough to solve the exercise together with
   the comments in the file. Hints are raw strings, so use 'single quotes' around
   code instead of backticks.
7. Rebuild and run the checks:

   ```sh
   ./build.sh
   ./odinlings dev check
   ```

`dev check` makes sure that the table and the files on disk agree, that every
exercise fails before it is solved, and that every solution passes. Solutions are
checked with the strict flags `-vet -vet-tabs -vet-style -strict-style
-disallow-do`, so they must be formatted in the Odin style: tabs for indentation,
braces on the same line, trailing commas in multi-line lists.

## Writing good exercises

- **One idea per exercise.** The learner should be able to tell what the exercise
  is about from its first comment.
- **Make the compiler or the tests do the talking.** The best exercises fail with a
  clear compiler error or test message that points at the problem.
- **Be self-contained.** Everything needed to solve an exercise should be explained
  in this exercise or an earlier one.
- **Write it yourself.** Exercises, comments and hints must be original work. Don't
  copy text or code from books, courses or other exercise collections.
- **Free what you allocate**, in exercises, solutions and tests alike.

## Working on the CLI

The CLI is plain Odin with no dependencies outside the core library. Build it and
run its tests with:

```sh
./build.sh test        # on Windows: build.bat test
```

Please keep the CLI building cleanly with `-vet -vet-tabs -vet-style -strict-style
-warnings-as-errors` (which `build.sh` uses) on Linux, macOS and Windows.

## Odin versions

Odinlings follows the current Odin release. The minimum version is
`MIN_ODIN_VERSION` in `cli/config.odin`, and CI runs against the same version. When
you update it, update `.github/workflows/ci.yml` and `README.md` as well.
