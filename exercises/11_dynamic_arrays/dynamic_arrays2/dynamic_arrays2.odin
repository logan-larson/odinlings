// dynamic_arrays2
//
// There are a few ways to take elements out of a dynamic array:
//
//     ordered_remove(&arr, i)     // removes arr[i]; later elements move
//                                 // down one place, keeping their order
//     unordered_remove(&arr, i)   // replaces arr[i] with the last element;
//                                 // faster, but the order changes
//     x := pop(&arr)              // removes and returns the last element
//
// They all need a pointer to the array, because they change its length. A
// procedure that changes a dynamic array therefore takes a `^[dynamic]T`.
//
// Removing elements while looping over the same array is tricky: after a
// removal, the next element moves into the current position. Looping from
// the back avoids that, because only elements you have already visited
// move:
//
//     #reverse for x, i in arr { ... }
package main

import "core:testing"

// Removes every negative number from `numbers`, keeping the order of the
// others.
//
// TODO: This misses some of the negative numbers. Find out why, and fix it.
remove_negatives :: proc(numbers: ^[dynamic]int) {
	for i := 0; i < len(numbers); i += 1 {
		if numbers[i] < 0 {
			ordered_remove(numbers, i)
		}
	}
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
