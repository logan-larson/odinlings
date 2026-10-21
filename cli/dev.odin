package odinlings

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"

// `odinlings dev check`: validates the exercise table, the files on disk,
// that every exercise fails before it is solved, and that every solution
// passes the strict checks.
dev_check :: proc(app: ^App_State) -> bool {
	check_table() or_return
	check_files(app) or_return
	check_unsolved(app) or_return
	check_solutions(app) or_return
	b := strings.builder_make(context.temp_allocator)
	styled(&b, "Everything looks fine!", BOLD, FG_GREEN)
	strings.write_string(&b, "\n")
	flush(&b)
	return true
}

@(private = "file")
dev_error :: proc(format: string, args: ..any) -> bool {
	b := strings.builder_make(context.temp_allocator)
	styled(&b, "error:", BOLD, FG_RED)
	strings.write_string(&b, " ")
	fmt.sbprintf(&b, format, ..args)
	strings.write_string(&b, "\n")
	flush(&b, os.stderr)
	return false
}

@(private = "file")
valid_ident :: proc(s: string) -> bool {
	if len(s) == 0 || len(s) > MAX_NAME_LEN {
		return false
	}
	for c in s {
		switch c {
		case 'a' ..= 'z', 'A' ..= 'Z', '0' ..= '9', '_':
		case:
			return false
		}
	}
	return true
}

@(private = "file")
check_table :: proc() -> bool {
	if len(EXERCISES) == 0 {
		return dev_error("there are no exercises")
	}
	if len(EXERCISES) > MAX_EXERCISES {
		return dev_error("there are %d exercises; at most %d are supported", len(EXERCISES), MAX_EXERCISES)
	}
	seen := make(map[string]bool, context.temp_allocator)
	for info in EXERCISES {
		if !valid_ident(info.name) {
			return dev_error("invalid exercise name '%s': use 1-%d characters of [A-Za-z0-9_]", info.name, MAX_NAME_LEN)
		}
		if !valid_ident(info.dir) {
			return dev_error("exercise '%s' has an invalid dir '%s'", info.name, info.dir)
		}
		if info.name in seen {
			return dev_error("exercise name '%s' is used more than once", info.name)
		}
		seen[info.name] = true
		if strings.trim_space(info.hint) == "" {
			return dev_error("exercise '%s' has no hint", info.name)
		}
		if info.expected_output != "" {
			if info.mode != .Run {
				return dev_error("exercise '%s' sets expected_output but is not a .Run exercise", info.name)
			}
			if normalize_output(info.expected_output, context.temp_allocator) != info.expected_output {
				return dev_error("the expected_output of '%s' has trailing whitespace or trailing empty lines", info.name)
			}
		}
		if info.track_memory && info.mode != .Test {
			return dev_error("exercise '%s' sets track_memory but is not a .Test exercise", info.name)
		}
	}
	return true
}

@(private = "file")
check_files :: proc(app: ^App_State) -> bool {
	topic_dirs := make(map[string]bool, context.temp_allocator)
	for ex in app.exercises {
		topic_dirs[ex.dir] = true

		data, err := os.read_entire_file(ex.path, context.temp_allocator)
		if err != nil {
			return dev_error("could not read %s: %s", ex.path, os.error_string(err))
		}
		src := string(data)
		if !strings.contains(src, "package main") {
			return dev_error("%s must be in `package main`", ex.path)
		}
		if strings.count(src, "main :: proc(") != 1 {
			return dev_error("%s must contain exactly one `main :: proc(`", ex.path)
		}
		if !strings.contains(src, "// TODO") {
			return dev_error("%s has no `// TODO` comment telling the learner what to do", ex.path)
		}
		has_test := strings.contains(src, "@(test)")
		if ex.mode == .Test && !has_test {
			return dev_error("%s is a .Test exercise but has no `@(test)` procedure", ex.path)
		}
		if ex.mode == .Run && has_test {
			return dev_error("%s contains `@(test)` but is a .Run exercise (set mode = .Test)", ex.path)
		}

		readme := fmt.tprintf("exercises/%s/README.md", ex.dir)
		readme_data, readme_err := os.read_entire_file(readme, context.temp_allocator)
		if readme_err != nil {
			return dev_error("missing %s", readme)
		}
		if !strings.has_prefix(string(readme_data), "# ") || !strings.contains(string(readme_data), "## Further information") {
			return dev_error("%s must start with a `# Title` and have a `## Further information` section", readme)
		}
	}

	check_tree(app, "exercises", topic_dirs, true) or_return
	check_tree(app, "solutions", topic_dirs, false) or_return
	return true
}

// Makes sure `root` contains nothing but README.md, the topic directories and
// one directory per exercise holding exactly `<name>.odin`.
@(private = "file")
check_tree :: proc(app: ^App_State, root: string, topic_dirs: map[string]bool, topic_readmes: bool) -> bool {
	entries, err := os.read_all_directory_by_path(root, context.temp_allocator)
	if err != nil {
		return dev_error("could not read %s/: %s", root, os.error_string(err))
	}
	for e in entries {
		if e.name == "README.md" && e.type == .Regular {
			continue
		}
		if e.type != .Directory || !(e.name in topic_dirs) {
			return dev_error("unexpected file %s/%s", root, e.name)
		}
		sub := fmt.tprintf("%s/%s", root, e.name)
		sub_entries, sub_err := os.read_all_directory_by_path(sub, context.temp_allocator)
		if sub_err != nil {
			return dev_error("could not read %s/: %s", sub, os.error_string(sub_err))
		}
		for se in sub_entries {
			if se.name == "README.md" && se.type == .Regular && topic_readmes {
				continue
			}
			idx, found := find_exercise(app, se.name)
			if se.type != .Directory || !found || app.exercises[idx].dir != e.name {
				return dev_error("unexpected file %s/%s (not an exercise of this topic in the table)", sub, se.name)
			}
			ex_dir := fmt.tprintf("%s/%s", sub, se.name)
			files, files_err := os.read_all_directory_by_path(ex_dir, context.temp_allocator)
			if files_err != nil {
				return dev_error("could not read %s/: %s", ex_dir, os.error_string(files_err))
			}
			expected := fmt.tprintf("%s.odin", se.name)
			if len(files) != 1 || files[0].name != expected {
				return dev_error("%s/ must contain exactly one file, %s", ex_dir, expected)
			}
		}
	}

	if root == "solutions" {
		for ex in app.exercises {
			path := solution_path(ex.info, context.temp_allocator)
			if !os.is_file(path) {
				return dev_error("missing solution %s", path)
			}
		}
	}
	return true
}

@(private = "file")
Progress_Ctx :: struct {
	finished: int,
	total:    int,
	label:    string,
}

@(private = "file")
print_progress :: proc(data: rawptr, _: Run_Done) {
	ctx := (^Progress_Ctx)(data)
	ctx.finished += 1
	if !os.is_tty(os.stdout) {
		if ctx.finished == ctx.total {
			fmt.printfln("%s: %d/%d", ctx.label, ctx.finished, ctx.total)
		}
		return
	}
	b := strings.builder_make(context.temp_allocator)
	fmt.sbprintf(&b, "\r%s: %d/%d", ctx.label, ctx.finished, ctx.total)
	clear_line(&b)
	flush(&b)
}

@(private = "file")
check_unsolved :: proc(app: ^App_State) -> bool {
	jobs := make([dynamic]Run_Job, context.temp_allocator)
	for ex, i in app.exercises {
		if !ex.skip_check_unsolved {
			append(&jobs, Run_Job{idx = i, info = ex.info})
		}
	}
	ctx := Progress_Ctx{total = len(jobs), label = "Checking that unsolved exercises fail"}
	results := run_many(app.tool, jobs[:], print_progress, &ctx, allocator = context.temp_allocator)
	if os.is_tty(os.stdout) {
		os.write_string(os.stdout, "\n")
	}
	slice.sort_by(results, proc(a, b: Run_Done) -> bool { return a.idx < b.idx })
	for r in results {
		if r.success {
			ex := app.exercises[r.idx]
			return dev_error(
				"the exercise '%s' passes before it was solved. Exercises must fail until the learner fixes them (or set skip_check_unsolved)",
				ex.name,
			)
		}
	}
	return true
}

@(private = "file")
check_solutions :: proc(app: ^App_State) -> bool {
	jobs := make([]Run_Job, len(app.exercises), context.temp_allocator)
	for ex, i in app.exercises {
		jobs[i] = Run_Job{idx = i, info = ex.info, opts = {strict = true, use_solution = true}}
	}
	ctx := Progress_Ctx{total = len(jobs), label = "Checking the solutions"}
	results := run_many(app.tool, jobs, print_progress, &ctx, keep_output = true, allocator = context.temp_allocator)
	if os.is_tty(os.stdout) {
		os.write_string(os.stdout, "\n")
	}
	slice.sort_by(results, proc(a, b: Run_Done) -> bool { return a.idx < b.idx })
	for r in results {
		if !r.success {
			os.write_string(os.stdout, r.output)
			return dev_error("the solution of '%s' does not pass the strict checks (see the output above)", app.exercises[r.idx].name)
		}
	}
	return true
}
