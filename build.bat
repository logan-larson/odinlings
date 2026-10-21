@echo off
rem Builds the odinlings CLI. Run it from the repository root:
rem
rem     build.bat        build odinlings.exe
rem     build.bat test   also build the fixture CLI and run the CLI tests
setlocal
cd /d "%~dp0"

set STRICT=-vet -vet-tabs -vet-style -strict-style -warnings-as-errors

odin build cli -out:odinlings.exe %STRICT% || exit /b 1
echo Built odinlings.exe. Run it with: odinlings

if "%1"=="test" (
	odin build cli -out:tests\odinlings-fixture.exe -define:ODINLINGS_FIXTURE=true %STRICT% || exit /b 1
	odin test tests\cli -define:ODIN_TEST_THREADS=1 -define:ODIN_TEST_FANCY=false %STRICT% || exit /b 1
)
