// strings3
//
// Gluing strings together with lots of small allocations is slow and leaves
// a mess to clean up. A `strings.Builder` collects text in one growing
// buffer instead:
//
//     b := strings.builder_make(allocator)
//     strings.write_string(&b, "Hello")
//     strings.write_byte(&b, ',')
//     fmt.sbprintf(&b, " %s! You are %d.", "Ada", 36)
//     s := strings.to_string(b)    // "Hello, Ada! You are 36."
//
// `strings.to_string` doesn't copy: the string points into the builder's
// buffer. The buffer is freed with `strings.builder_destroy(&b)` (or with
// the allocator, like the temp allocator's `free_all`).
package main

import "core:strings"
import "core:testing"

// Joins the numbers into one string, like "1, 2, 3".
//
// TODO: Write the numbers into the builder, with ", " between them (but not
// after the last one). `fmt.sbprintf` can write a number into a builder;
// import "core:fmt" to use it.
join_numbers :: proc(numbers: []int, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	return strings.to_string(b)
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_join_numbers :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	testing.expect_value(t, join_numbers({1, 2, 3}, context.temp_allocator), "1, 2, 3")
	testing.expect_value(t, join_numbers({42}, context.temp_allocator), "42")
	testing.expect_value(t, join_numbers({}, context.temp_allocator), "")
}
