// slices3
//
// A slice literal creates a slice together with the elements it looks at:
//
//     names := []string{"Ada", "Bob"}
//
// The elements live in the current scope, like a local array, so don't keep
// such a slice around after the scope ends.
//
// The zero value of a slice is `nil`, an empty slice with length 0. An empty
// slice has no elements at all, so indexing it is always out of bounds.
// Reading outside of a slice is caught while the program runs (a "bounds
// check") and stops it with an error.
package main

import "core:testing"

// Returns the first name, or `fallback` if there are no names.
//
// TODO: This crashes when `names` is empty. Check the length first.
first_or :: proc(names: []string, fallback: string) -> string {
	return names[0]
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_first :: proc(t: ^testing.T) {
	testing.expect_value(t, first_or([]string{"Ada", "Bob"}, "nobody"), "Ada")
}

@(test)
test_empty :: proc(t: ^testing.T) {
	testing.expect_value(t, first_or([]string{}, "nobody"), "nobody")
	testing.expect_value(t, first_or(nil, "nobody"), "nobody")
}
