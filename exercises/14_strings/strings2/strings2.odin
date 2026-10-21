// strings2
//
// The "core:strings" package has many procedures for working with strings:
//
//     strings.trim_space("  hi  ")          // "hi"
//     strings.has_prefix("odinlings", "odin") // true
//     strings.contains("hellope", "llo")    // true
//     strings.to_upper("hi", allocator)     // "HI"
//
// Strings in Odin can't be changed in place. Procedures that only look at a
// part of a string, like `trim_space`, return a view into the original
// string and allocate nothing. Procedures that produce new text, like
// `to_upper`, allocate memory for it. They take an allocator parameter,
// which defaults to `context.allocator`.
//
// The procedure below takes an allocator too, and the tests pass the temp
// allocator so they don't have to free each result.
package main

import "core:strings"
import "core:testing"

// Turns user input like "  Ada LOVELACE " into "ada lovelace".
//
// TODO: Also convert the name to lower case, using `allocator` for the new
// string.
normalize_name :: proc(name: string, allocator := context.allocator) -> string {
	return strings.trim_space(name)
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_normalize_name :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	testing.expect_value(t, normalize_name("  Ada LOVELACE ", context.temp_allocator), "ada lovelace")
	testing.expect_value(t, normalize_name("grace", context.temp_allocator), "grace")
	testing.expect_value(t, normalize_name("\tLINUS\n", context.temp_allocator), "linus")
}
