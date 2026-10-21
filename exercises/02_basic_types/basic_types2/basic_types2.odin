// basic_types2
//
// Floating point numbers have the types f16, f32 and f64. Dividing two
// integers gives an integer, and the remainder is thrown away: 7 / 2 is 3.
// To get 3.5, at least one side must be a float: f64(7) / 2.
//
// Number literals like `2` are "untyped constants": they become whatever
// number type the expression needs, so `f64(x) / 2` works without `2.0`.
//
// This exercise has tests. It passes once all the procedures marked
// `@(test)` at the bottom pass. You don't need to change `main`.
package main

import "core:testing"

// TODO: Return the average of `a` and `b` as an f64, keeping the fractional
// part.
average :: proc(a, b: int) -> f64 {
	return (a + b) / 2
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_whole_average :: proc(t: ^testing.T) {
	testing.expect_value(t, average(4, 8), 6)
}

@(test)
test_fractional_average :: proc(t: ^testing.T) {
	testing.expect_value(t, average(1, 2), 1.5)
	testing.expect_value(t, average(-3, 0), -1.5)
}
