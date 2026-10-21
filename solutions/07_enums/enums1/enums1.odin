// enums1
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// Every direction has its own case now.
turn_right :: proc(d: Direction) -> Direction {
	switch d {
	case .North:
		return .East
	case .East:
		return .South
	case .South:
		return .West
	case .West:
		return .North
	}
	return d
}

main :: proc() {
}

@(test)
test_turn_right :: proc(t: ^testing.T) {
	testing.expect_value(t, turn_right(.North), Direction.East)
	testing.expect_value(t, turn_right(.East), Direction.South)
	testing.expect_value(t, turn_right(.South), Direction.West)
	testing.expect_value(t, turn_right(.West), Direction.North)
}
