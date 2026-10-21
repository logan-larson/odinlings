// control_flow3
//
// `switch` compares one value against several cases. Unlike in C, a case
// does not continue ("fall through") into the next one, so there is no
// `break` at the end of each case. A case can list several values or a
// range of values, and `case:` on its own is the default case:
//
//     switch day {
//     case 0, 6:
//         fmt.println("weekend")
//     case 1 ..= 5:
//         fmt.println("weekday")
//     case:
//         fmt.println("not a day")
//     }
//
// If you do want to continue into the next case, write `fallthrough`.
package main

import "core:testing"

// TODO: Scores from 90 up to and including 100 are an "A". One of the tests
// fails. Find out which, and fix `grade`.
grade :: proc(score: int) -> string {
	switch score {
	case 90 ..< 100:
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
	// You can optionally experiment here.
}

// Don't change the tests!

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
