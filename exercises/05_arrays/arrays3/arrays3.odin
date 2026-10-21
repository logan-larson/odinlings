// arrays3
//
// Fixed arrays are values, just like numbers. Assigning an array to another
// variable copies every element, and so does passing it to a procedure:
//
//     a := [3]int{1, 2, 3}
//     b := a          // b is a copy
//     b[0] = 100      // a is still {1, 2, 3}
//
// Remember that procedure parameters can't be assigned to. That includes
// the elements of an array parameter. To produce a changed array, make a
// local copy, change the copy, and return it.
package main

import "core:testing"

// TODO: Return a new array where every number is doubled. The compiler
// doesn't allow changing `scores` itself.
doubled :: proc(scores: [4]int) -> [4]int {
	for i in 0 ..< len(scores) {
		scores[i] *= 2
	}
	return scores
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_doubled :: proc(t: ^testing.T) {
	testing.expect_value(t, doubled({1, 2, 3, 4}), [4]int{2, 4, 6, 8})
}

@(test)
test_original_is_unchanged :: proc(t: ^testing.T) {
	original := [4]int{5, 0, -5, 10}
	result := doubled(original)
	testing.expect_value(t, result, [4]int{10, 0, -10, 20})
	testing.expect_value(t, original, [4]int{5, 0, -5, 10})
}
