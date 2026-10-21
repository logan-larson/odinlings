# Odinlings

Small exercises to get you used to reading and writing [Odin](https://odin-lang.org) code.

Odinlings hands you a series of tiny programs that are broken in some way: they
don't compile, they crash, they print the wrong thing or their tests fail. You fix
them one by one, and the `odinlings` tool watches your files, re-checks the current
exercise every time you save, and shows you what the compiler said. Along the way
you learn the core of the language: variables and types, procedures, control flow,
arrays, structs, enums and unions, pointers, slices, dynamic arrays and maps,
manual memory management, strings and error handling.

Odinlings is inspired by [rustlings](https://github.com/rust-lang/rustlings) and
[ziglings](https://codeberg.org/ziglings/exercises).

## Requirements

- **Odin `dev-2026-10` or newer.** See [Installing Odin](https://odin-lang.org/docs/install/).
  `odin` must be on your `PATH`, or set the `ODIN` environment variable to the
  compiler's path.
- **git**, to get the exercises (and to reset them).
- A terminal. Colours and clickable file paths work in most modern terminals,
  including Windows Terminal.

## Getting started

```sh
git clone https://github.com/logan-larson/odinlings
cd odinlings
./build.sh          # on Windows: build.bat
./odinlings         # on Windows: odinlings
```

Then open the `odinlings` directory in your editor and follow the instructions in
the terminal. The path of the current exercise is always shown under the progress
bar.

Each exercise lives in its own directory, for example
`exercises/01_variables/variables1/variables1.odin`. In Odin a directory is a
package, so every exercise is a complete little program. You can also build and run
one yourself:

```sh
odin run exercises/01_variables/variables1
odin test exercises/03_procedures/procedures2   # exercises with tests
```

## Watch mode

Running `odinlings` without arguments starts watch mode. It checks the current
exercise, shows the result, and checks it again every time you save the file. Once
an exercise passes you can keep experimenting with it, and move on when you're
ready. These keys work in watch mode (no need to press Enter):

| Key | Action |
| --- | --- |
| `n` | Move on to the next exercise (once the current one passes) |
| `h` | Show a hint for the current exercise |
| `l` | Open the list of all exercises |
| `x` | Reset the current exercise (asks first) |
| `r` | Check the exercise again (only with `-manual-run`) |
| `q` | Quit |

In the list, move with `j`/`k` or the arrow keys, jump to the first or last
exercise with `g`/`G`, press `Enter` or `c` to continue at the selected exercise,
`r` to reset it, and `q` to go back.

## Commands

| Command | What it does |
| --- | --- |
| `odinlings` | Start watch mode |
| `odinlings -manual-run` | Watch mode without watching files; press `r` to check |
| `odinlings run [NAME]` | Check an exercise once (default: the current one) |
| `odinlings hint [NAME]` | Show the hint of an exercise |
| `odinlings reset NAME` | Undo your changes to an exercise (uses `git checkout`) |
| `odinlings check-all` | Check every exercise and update your progress |
| `odinlings list` | List all exercises and whether they are done |
| `odinlings dev check` | Validate the exercises and solutions (for contributors) |
| `odinlings help` | Show the usage |

Add `-no-color` to any command to turn off colours and links. The `NO_COLOR`
environment variable is honoured too.

## How exercises are checked

An exercise passes when:

- it compiles with `-vet-unused` (unused variables and imports are errors) and
  `-warnings-as-errors`, and
- it runs and exits successfully, printing exactly the expected output if the
  exercise expects one, or
- for exercises with tests, all of its `@(test)` procedures pass under `odin test`.

Some exercises also fail when they leak memory. The test runner then shows where
the leaked memory was allocated.

Your progress is stored in `.odinlings-state.txt`, and compiled exercises go into
`.odinlings/`. Both are ignored by git. To start over, delete
`.odinlings-state.txt` and reset the exercises with `git checkout -- exercises`.

Reference solutions are in `solutions/`. Try not to peek before you've solved an
exercise; Odinlings shows the path of the solution once your version passes.

## Troubleshooting

- **"Could not run the Odin compiler"**: make sure `odin version` works in the same
  terminal, or set `ODIN=/path/to/odin`.
- **"odinlings needs Odin dev-2026-10 or newer"**: update Odin. Odin is still
  changing quickly, and the exercises follow the current release.
- **Saving a file doesn't trigger a check**: some editors save in unusual ways.
  Start Odinlings with `./odinlings -manual-run` and press `r` to check.
- **`reset` fails**: resetting uses `git checkout`, so it only works inside a git
  clone. If you committed your own changes, `reset` brings back your last commit
  rather than the original exercise.
- **The terminal looks wrong after a crash**: run `reset` (the shell command) to
  restore the terminal settings.
- Run only one `odinlings` at a time in a checkout; they share the progress file
  and the build directory.

## Editor setup

Install [OLS](https://github.com/DanielGavin/ols), the Odin language server, for
completions and errors in your editor. In VS Code, install the recommended
"Odin Language" extension (`DanielGavin.ols`). The repository contains a minimal
`ols.json`.

## Contributing

Found a mistake, a confusing explanation, or have an idea for an exercise? Issues
and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Odinlings is available under the MIT license. See [LICENSE](LICENSE).
