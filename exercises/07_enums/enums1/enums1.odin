// enums1
//
// An enum is a type whose values come from a fixed list of names:
//
//     Suit :: enum {
//         Hearts,
//         Diamonds,
//         Clubs,
//         Spades,
//     }
//
//     s := Suit.Clubs
//     s = .Spades        // the type is known, so `.Spades` is enough
//
// A `switch` over an enum has to handle every value. If you forget one, the
// compiler tells you. That makes it easy to find every place you need to
// update when the enum grows.
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// TODO: Turning right from West leads North. The compiler has noticed that
// this case is missing.
turn_right :: proc(d: Direction) -> Direction {
	switch d {
	case .North:
		return .East
	case .East:
		return .South
	case .South:
		return .West
	}
	return d
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_turn_right :: proc(t: ^testing.T) {
	testing.expect_value(t, turn_right(.North), Direction.East)
	testing.expect_value(t, turn_right(.East), Direction.South)
	testing.expect_value(t, turn_right(.South), Direction.West)
	testing.expect_value(t, turn_right(.West), Direction.North)
}
