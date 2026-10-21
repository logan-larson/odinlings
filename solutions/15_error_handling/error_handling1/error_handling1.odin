// error_handling1
package main

import "core:testing"

// Named results start as zero and false, so the failure case can use a bare
// `return`.
parse_digit :: proc(r: rune) -> (value: int, ok: bool) {
	if r >= '0' && r <= '9' {
		return int(r - '0'), true
	}
	return
}

main :: proc() {
}

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
