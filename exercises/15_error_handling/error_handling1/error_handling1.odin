// error_handling1
//
// Odin has no exceptions. A procedure that might fail tells the caller with
// an extra result. The simplest version is a bool that says whether it
// worked, conventionally called `ok`:
//
//     find_user :: proc(id: int) -> (user: User, ok: bool) { ... }
//
//     user, ok := find_user(7)
//     if !ok {
//         // handle the problem
//     }
package main

import "core:testing"

// Converts a digit character like '7' into the number 7.
//
// TODO: Callers need to know when the rune isn't a digit at all. Return a
// second result, `ok`, which is false in that case.
parse_digit :: proc(r: rune) -> int {
	if r >= '0' && r <= '9' {
		return int(r - '0')
	}
	return 0
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_digits :: proc(t: ^testing.T) {
	value, ok := parse_digit('7')
	testing.expect(t, ok)
	testing.expect_value(t, value, 7)

	value, ok = parse_digit('0')
	testing.expect(t, ok)
	testing.expect_value(t, value, 0)
}

@(test)
test_not_a_digit :: proc(t: ^testing.T) {
	_, ok := parse_digit('x')
	testing.expect(t, !ok)
}
