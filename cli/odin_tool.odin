package odinlings

import "core:fmt"
import "core:os"
import "core:strings"

Odin_Tool :: struct {
	exe:     string, // the compiler: $ODIN, or "odin" looked up on PATH
	version: string, // e.g. "dev-2026-10"; empty if it could not be parsed
	root:    string, // absolute path of the directory odinlings runs in
}

// Finds the Odin compiler and checks that it is new enough.
odin_tool_init :: proc() -> (tool: Odin_Tool, ok: bool) {
	tool.exe = "odin"
	if env, found := os.lookup_env("ODIN", context.allocator); found && env != "" {
		tool.exe = env
	}

	root, root_err := os.get_working_directory(context.allocator)
	if root_err != nil {
		fmt.eprintln("Could not read the current directory:", os.error_string(root_err))
		return
	}
	tool.root = root

	out := strings.builder_make(context.temp_allocator)
	res, err := run_cmd({tool.exe, "version"}, "", &out, COMPILE_TIMEOUT)
	if err != nil || !res.exited || res.exit_code != 0 {
		fmt.eprintf("Could not run the Odin compiler (`%s version`)", tool.exe)
		if err != nil {
			fmt.eprintf(": %s", os.error_string(err))
		}
		fmt.eprintln(".")
		fmt.eprintln("Install Odin (https://odin-lang.org/docs/install/) and make sure `odin` is on")
		fmt.eprintln("your PATH, or set the ODIN environment variable to the compiler's path.")
		return
	}

	tool.version = parse_odin_version(strings.to_string(out))
	if tool.version == "" {
		fmt.eprintfln("Warning: could not read the Odin version from `%s version`; continuing anyway.", tool.exe)
	} else if !odin_version_at_least(tool.version, MIN_ODIN_VERSION) {
		fmt.eprintfln("odinlings needs Odin %s or newer, but found %s.", MIN_ODIN_VERSION, tool.version)
		fmt.eprintln("Please update Odin: https://odin-lang.org/docs/install/")
		return
	}
	ok = true
	return
}

// Extracts "dev-YYYY-MM" from output like "odin version dev-2026-10:84bc3fc".
parse_odin_version :: proc(output: string) -> string {
	idx := strings.index(output, "dev-")
	if idx < 0 {
		return ""
	}
	rest := output[idx:]
	// "dev-" + "YYYY-MM"
	if len(rest) < 11 {
		return ""
	}
	v := rest[:11]
	for c, i in v[4:] {
		if i == 4 {
			if c != '-' {
				return ""
			}
		} else if c < '0' || c > '9' {
			return ""
		}
	}
	return strings.clone(v)
}

// Both versions look like "dev-YYYY-MM"; they compare correctly as strings.
odin_version_at_least :: proc(have, want: string) -> bool {
	return have >= want
}

