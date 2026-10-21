// slices2
package main

import "core:testing"

// `&x` makes `x` refer to the element itself instead of a copy of it.
fill :: proc(s: []int, value: int) {
	for &x in s {
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
}

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
