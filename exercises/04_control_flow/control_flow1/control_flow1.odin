// control_flow1
//
// `if` needs no parentheses around its condition, but the braces are
// required:
//
//     if temperature < 0 {
//         fmt.println("freezing")
//     } else if temperature < 20 {
//         fmt.println("chilly")
//     } else {
//         fmt.println("warm")
//     }
//
// An `if` can begin with a short statement followed by `;`. A variable
// declared there only exists inside the `if` and its `else` branches:
//
//     if n := len(name); n > 10 {
//         fmt.println("that's a long name:", n, "bytes")
//     }
package main

import "core:testing"

// TODO: Return "negative", "zero" or "positive", depending on `n`.
sign :: proc(n: int) -> string {
	if n < 0 {
		return "negative"
	}
	return "positive"
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
