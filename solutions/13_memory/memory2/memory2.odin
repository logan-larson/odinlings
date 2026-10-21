// memory2
package main

import "core:testing"

sum_of_even_squares :: proc(numbers: []int) -> int {
	evens := make([dynamic]int)
	// Freed when the procedure returns.
	defer delete(evens)
	for n in numbers {
		if n % 2 == 0 {
			append(&evens, n)
		}
	}

	total := 0
	for e in evens {
		total += e * e
	}
	return total
}

main :: proc() {
}

@(test)
test_sum_of_even_squares :: proc(t: ^testing.T) {
	testing.expect_value(t, sum_of_even_squares({1, 2, 3, 4}), 20)
	testing.expect_value(t, sum_of_even_squares({5, 7}), 0)
}
