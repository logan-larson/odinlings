// strings3
package main

import "core:fmt"
import "core:strings"
import "core:testing"

join_numbers :: proc(numbers: []int, allocator := context.allocator) -> string {
	b := strings.builder_make(allocator)
	for n, i in numbers {
		if i > 0 {
			strings.write_string(&b, ", ")
		}
		fmt.sbprintf(&b, "%d", n)
	}
	// The returned string points into the builder's buffer, which belongs to
	// the caller (through `allocator`).
	return strings.to_string(b)
}

main :: proc() {
}

@(test)
test_join_numbers :: proc(t: ^testing.T) {
	defer free_all(context.temp_allocator)
	testing.expect_value(t, join_numbers({1, 2, 3}, context.temp_allocator), "1, 2, 3")
	testing.expect_value(t, join_numbers({42}, context.temp_allocator), "42")
	testing.expect_value(t, join_numbers({}, context.temp_allocator), "")
}
