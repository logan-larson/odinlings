#!/bin/sh
# Builds the odinlings CLI. Run it from the repository root:
#
#     ./build.sh        build ./odinlings
#     ./build.sh test   also build the fixture CLI and run the CLI tests
set -e
cd "$(dirname "$0")"

STRICT="-vet -vet-tabs -vet-style -strict-style -warnings-as-errors"

odin build cli -out:odinlings $STRICT
echo "Built ./odinlings. Run it with: ./odinlings"

if [ "$1" = "test" ]; then
	odin build cli -out:tests/odinlings-fixture -define:ODINLINGS_FIXTURE=true $STRICT
	odin test tests/cli -define:ODIN_TEST_THREADS=1 -define:ODIN_TEST_FANCY=false $STRICT
fi
