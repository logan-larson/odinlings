// enums3
//
// An enumerated array has exactly one element for each value of an enum,
// and it is indexed with the enum instead of a number:
//
//     Color :: enum { Red, Green, Blue }
//     names := [Color]string{
//         .Red   = "rouge",
//         .Green = "vert",
//         .Blue  = "bleu",
//     }
//     names[.Green]    // "vert"
//
// Sometimes a switch only cares about a few values of an enum. Mark it with
// `#partial` to tell the compiler that leaving out the other cases is on
// purpose:
//
//     #partial switch c {
//     case .Red:
//         fmt.println("stop")
//     }
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// Moves one step from `pos` in direction `d`. North is up, so it makes y
// smaller.
//
// TODO: Pick the delta that belongs to `d`.
step :: proc(pos: [2]int, d: Direction) -> [2]int {
	deltas := [Direction][2]int {
		.North = {0, -1},
		.East  = {1, 0},
		.South = {0, 1},
		.West  = {-1, 0},
	}
	return pos + deltas[0]
}

// TODO: This switch only cares about two of the directions. Tell the compiler
// that's on purpose.
is_vertical :: proc(d: Direction) -> bool {
	switch d {
	case .North, .South:
		return true
	}
	return false
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
