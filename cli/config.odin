package odinlings

import "core:time"

// Build the CLI with `-define:ODINLINGS_FIXTURE=true` to use the small
// fixture table in `info_fixture.odin` (used by the CLI tests).
ODINLINGS_FIXTURE :: #config(ODINLINGS_FIXTURE, false)

VERSION          :: "0.1.0"
MIN_ODIN_VERSION :: "dev-2026-10"

STATE_FILE :: ".odinlings-state.txt"
BUILD_DIR  :: ".odinlings/build"
EXE_EXT    :: ".exe" when ODIN_OS == .Windows else ""

// Time limit for one `odin build`/`odin test` invocation.
COMPILE_TIMEOUT :: 60 * time.Second
// Time limit for running a compiled exercise.
RUN_TIMEOUT     :: 30 * time.Second

// Watch mode: how long to wait after the last file change before re-running.
DEBOUNCE         :: 200 * time.Millisecond
POLL_INTERVAL_MS :: 100

MAX_EXERCISES :: 999
MAX_NAME_LEN  :: 32
