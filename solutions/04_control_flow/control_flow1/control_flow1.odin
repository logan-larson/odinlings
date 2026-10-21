// control_flow1
package main

import "core:testing"

sign :: proc(n: int) -> string {
	if n < 0 {
		return "negative"
	} else if n == 0 {
		return "zero"
	}
	return "positive"
}

main :: proc() {
}

@(test)
test_negative :: proc(t: ^testing.T) {
	testing.expect_value(t, sign(-5), "negative")
}

@(test)
test_zero :: proc(t: ^testing.T) {
	testing.expect_value(t, sign(0), "zero")
}

@(test)
test_positive :: proc(t: ^testing.T) {
	testing.expect_value(t, sign(42), "positive")
}
