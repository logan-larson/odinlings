// unions2
package main

import "core:testing"

// `nil` is the empty Maybe. Returning `i` wraps the int in the Maybe
// automatically.
find_index :: proc(haystack: [5]int, needle: int) -> Maybe(int) {
	for value, i in haystack {
		if value == needle {
			return i
		}
	}
	return nil
}

main :: proc() {
}

@(test)
test_found :: proc(t: ^testing.T) {
	index, ok := find_index({4, 8, 15, 16, 23}, 15).?
	testing.expect(t, ok)
	testing.expect_value(t, index, 2)
}

@(test)
test_not_found :: proc(t: ^testing.T) {
	_, ok := find_index({4, 8, 15, 16, 23}, 42).?
	testing.expect(t, !ok, "42 is not in the array, so there should be no index")
	fallback := find_index({1, 2, 3, 4, 5}, 9).? or_else 100
	testing.expect_value(t, fallback, 100)
}
