// dynamic_arrays2
package main

import "core:testing"

// Going backwards, a removal only moves elements that were already checked.
// (The forward loop skipped the element right after each removed one.)
remove_negatives :: proc(numbers: ^[dynamic]int) {
	#reverse for n, i in numbers {
		if n < 0 {
			ordered_remove(numbers, i)
		}
	}
}

main :: proc() {
}

@(test)
test_remove_negatives :: proc(t: ^testing.T) {
	numbers: [dynamic]int
	defer delete(numbers)
	append(&numbers, 1, -2, -3, 4, -5, -6, 7)

	remove_negatives(&numbers)

	testing.expect_value(t, len(numbers), 3)
	if len(numbers) == 3 {
		testing.expect_value(t, numbers[0], 1)
		testing.expect_value(t, numbers[1], 4)
		testing.expect_value(t, numbers[2], 7)
	}
}

@(test)
test_only_negatives :: proc(t: ^testing.T) {
	numbers: [dynamic]int
	defer delete(numbers)
	append(&numbers, -1, -1, -1)

	remove_negatives(&numbers)

	testing.expect_value(t, len(numbers), 0)
}
