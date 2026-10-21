// dynamic_arrays1
package main

import "core:testing"

// The caller owns the returned array and has to `delete` it, as the tests
// do.
evens_up_to :: proc(n: int) -> [dynamic]int {
	result: [dynamic]int
	for i in 1 ..= n {
		if i % 2 == 0 {
			append(&result, i)
		}
	}
	return result
}

main :: proc() {
}

@(test)
test_evens_up_to_ten :: proc(t: ^testing.T) {
	evens := evens_up_to(10)
	defer delete(evens)
	testing.expect_value(t, len(evens), 5)
	for value, i in evens {
		testing.expect_value(t, value, (i + 1) * 2)
	}
}

@(test)
test_no_evens :: proc(t: ^testing.T) {
	evens := evens_up_to(1)
	defer delete(evens)
	testing.expect_value(t, len(evens), 0)
}
