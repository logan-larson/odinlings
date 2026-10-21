// procedures2
//
// A procedure can return several values. Put the result types in
// parentheses, and return the values separated by commas:
//
//     swap :: proc(a, b: int) -> (int, int) {
//         return b, a
//     }
//     x, y := swap(1, 2)    // x is 2, y is 1
//
// Results can also have names. Named results start at their zero value, and
// a bare `return` returns their current values:
//
//     sum_and_product :: proc(a, b: int) -> (sum, product: int) {
//         sum = a + b
//         product = a * b
//         return
//     }
package main

import "core:testing"

// TODO: Make `divide` return two values: the quotient and the remainder of
// `a / b`. The `%` operator gives the remainder.
divide :: proc(a, b: int) -> int {
	return a / b
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_divide_evenly :: proc(t: ^testing.T) {
	quotient, remainder := divide(10, 5)
	testing.expect_value(t, quotient, 2)
	testing.expect_value(t, remainder, 0)
}

@(test)
test_divide_with_remainder :: proc(t: ^testing.T) {
	quotient, remainder := divide(17, 5)
	testing.expect_value(t, quotient, 3)
	testing.expect_value(t, remainder, 2)
}
