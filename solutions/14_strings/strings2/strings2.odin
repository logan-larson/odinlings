// strings2
package main

import "core:strings"
import "core:testing"

// `trim_space` returns a view into `name`; `to_lower` copies it into new
// memory from `allocator` while lowering the case.
normalize_name :: proc(name: string, allocator := context.allocator) -> string {
	return strings.to_lower(strings.trim_space(name), allocator)
}

main :: proc() {
}

@(test)
test_normalize_name :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	testing.expect_value(t, normalize_name("  Ada LOVELACE ", context.temp_allocator), "ada lovelace")
	testing.expect_value(t, normalize_name("grace", context.temp_allocator), "grace")
	testing.expect_value(t, normalize_name("\tLINUS\n", context.temp_allocator), "linus")
}
