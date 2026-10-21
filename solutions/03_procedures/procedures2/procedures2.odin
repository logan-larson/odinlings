// procedures2
package main

import "core:testing"

// Named results document what each value means. They start at zero and are
// returned by the bare `return`. `return a / b, a % b` with unnamed results
// `-> (int, int)` works just as well.
divide :: proc(a, b: int) -> (quotient, remainder: int) {
	quotient = a / b
	remainder = a % b
	return
}

main :: proc() {
}

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
