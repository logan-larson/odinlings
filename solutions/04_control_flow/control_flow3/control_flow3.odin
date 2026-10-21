// control_flow3
package main

import "core:testing"

// `..=` makes the range include 100.
grade :: proc(score: int) -> string {
	switch score {
	case 90 ..= 100:
		return "A"
	case 80 ..< 90:
		return "B"
	case 70 ..< 80:
		return "C"
	case 0 ..< 70:
		return "F"
	}
	return "invalid"
}

main :: proc() {
}

@(test)
test_grades :: proc(t: ^testing.T) {
	testing.expect_value(t, grade(95), "A")
	testing.expect_value(t, grade(85), "B")
	testing.expect_value(t, grade(70), "C")
	testing.expect_value(t, grade(12), "F")
}

@(test)
test_edges :: proc(t: ^testing.T) {
	testing.expect_value(t, grade(100), "A")
	testing.expect_value(t, grade(0), "F")
	testing.expect_value(t, grade(101), "invalid")
	testing.expect_value(t, grade(-1), "invalid")
}
