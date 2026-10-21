# CLI tests

These tests check the `odinlings` command line tool itself, not the exercises.

`tests/cli/` runs a special build of the CLI that uses the small exercise table in
`cli/info_fixture.odin` instead of the real course. That build works on the
exercises in `tests/fixture/`, which compile or fail on purpose.

From the repository root:

```sh
./build.sh test
```

or by hand:

```sh
odin build cli -out:tests/odinlings-fixture -define:ODINLINGS_FIXTURE=true
odin test tests/cli -define:ODIN_TEST_THREADS=1
```

The tests share the fixture's progress file, so they must run on one thread.
