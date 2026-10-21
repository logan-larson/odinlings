// arrays3
package main

import "core:testing"

// `result` is a copy of the whole array, so changing it leaves the caller's
// array alone. (Thanks to array arithmetic, `return scores * 2` works too!)
doubled :: proc(scores: [4]int) -> [4]int {
	result := scores
	for i in 0 ..< len(result) {
		result[i] *= 2
	}
	return result
}

main :: proc() {
}

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
