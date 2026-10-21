// slices3
package main

import "core:testing"

// Both an empty slice literal and `nil` have a length of 0.
first_or :: proc(names: []string, fallback: string) -> string {
	if len(names) == 0 {
		return fallback
	}
	return names[0]
}

main :: proc() {
}

@(test)
test_first :: proc(t: ^testing.T) {
	testing.expect_value(t, first_or([]string{"Ada", "Bob"}, "nobody"), "Ada")
}

@(test)
test_empty :: proc(t: ^testing.T) {
	testing.expect_value(t, first_or([]string{}, "nobody"), "nobody")
	testing.expect_value(t, first_or(nil, "nobody"), "nobody")
}
