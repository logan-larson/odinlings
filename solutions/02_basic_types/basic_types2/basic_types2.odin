// basic_types2
package main

import "core:testing"

// Converting the sum to f64 before dividing keeps the fractional part.
// Note that f64((a + b) / 2) would compile, but the integer division would
// already have thrown the fraction away.
average :: proc(a, b: int) -> f64 {
	return f64(a + b) / 2
}

main :: proc() {
}

@(test)
test_whole_average :: proc(t: ^testing.T) {
	testing.expect_value(t, average(4, 8), 6)
}

@(test)
test_fractional_average :: proc(t: ^testing.T) {
	testing.expect_value(t, average(1, 2), 1.5)
	testing.expect_value(t, average(-3, 0), -1.5)
}
