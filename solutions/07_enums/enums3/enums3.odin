// enums3
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// The enumerated array is indexed with the direction itself.
step :: proc(pos: [2]int, d: Direction) -> [2]int {
	deltas := [Direction][2]int {
		.North = {0, -1},
		.East  = {1, 0},
		.South = {0, 1},
		.West  = {-1, 0},
	}
	return pos + deltas[d]
}

is_vertical :: proc(d: Direction) -> bool {
	#partial switch d {
	case .North, .South:
		return true
	}
	return false
}

main :: proc() {
}

@(test)
test_step :: proc(t: ^testing.T) {
	testing.expect_value(t, step({5, 5}, .North), [2]int{5, 4})
	testing.expect_value(t, step({5, 5}, .East), [2]int{6, 5})
	testing.expect_value(t, step({5, 5}, .South), [2]int{5, 6})
	testing.expect_value(t, step({5, 5}, .West), [2]int{4, 5})
}

@(test)
test_is_vertical :: proc(t: ^testing.T) {
	testing.expect(t, is_vertical(.North))
	testing.expect(t, is_vertical(.South))
	testing.expect(t, !is_vertical(.East))
	testing.expect(t, !is_vertical(.West))
}
