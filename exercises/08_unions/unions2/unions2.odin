// unions2
//
// A union can also be empty. Its zero value is `nil`, which means "holds
// nothing". The built-in `Maybe(T)` is a union with just one type, so a
// `Maybe(int)` holds either an int or nothing:
//
//     age: Maybe(int)          // nil to begin with
//     age = 31                 // now holds 31
//
// To get the value out, use `.?`. It gives the value and whether there was
// one:
//
//     value, ok := age.?
//
// Or add `or_else` to fall back to a default when there is nothing:
//
//     years := age.? or_else 0
package main

import "core:testing"

// Returns the position of `needle` in `haystack`, or nothing if it isn't
// there.
//
// TODO: When the number isn't found, this returns -1, which is a perfectly
// good int. Return "nothing" instead.
find_index :: proc(haystack: [5]int, needle: int) -> Maybe(int) {
	for value, i in haystack {
		if value == needle {
			return i
		}
	}
	return -1
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
