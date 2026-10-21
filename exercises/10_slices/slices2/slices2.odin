// slices2
//
// Procedures usually take slices rather than fixed arrays, because a slice
// works with any number of elements. To pass an array, slice it: `f(arr[:])`.
//
// A slice parameter can't be replaced, but the elements it points to can be
// changed. In a range loop, the loop variable is a copy of each element. To
// change the elements themselves, ask for a reference with `&`:
//
//     for &x in numbers {
//         x *= 2           // changes the element in `numbers`
//     }
package main

import "core:testing"

// TODO: Set every element of `s` to `value`.
fill :: proc(s: []int, value: int) {
	for x in s {
		x = value
	}
}

total :: proc(s: []int) -> int {
	sum := 0
	for x in s {
		sum += x
	}
	return sum
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_fill_everything :: proc(t: ^testing.T) {
	numbers: [5]int
	fill(numbers[:], 7)
	testing.expect_value(t, numbers, [5]int{7, 7, 7, 7, 7})
	testing.expect_value(t, total(numbers[:]), 35)
}

@(test)
test_fill_part :: proc(t: ^testing.T) {
	numbers := [5]int{1, 2, 3, 4, 5}
	fill(numbers[1:3], 0)
	testing.expect_value(t, numbers, [5]int{1, 0, 0, 4, 5})
	testing.expect_value(t, total(numbers[2:]), 9)
}
