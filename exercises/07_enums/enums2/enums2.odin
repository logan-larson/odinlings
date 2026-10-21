// enums2
//
// Behind the scenes, enum values are numbers. The first value is 0, the next
// is 1, and so on. You can convert in both directions:
//
//     int(Direction.South)    // 2
//     Direction(3)            // .West
//
// `len(Direction)` is the number of values in the enum, and a `for` loop can
// visit each of them:
//
//     for d in Direction {
//         fmt.println(d)      // prints North, East, South, West
//     }
//
// Careful: converting a number that is out of range gives a value that isn't
// any of the names.
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// Two steps clockwise from any direction is its opposite.
//
// TODO: This works for North and East, but South and West go past the end of
// the enum. Wrap around to the start with the remainder operator `%`.
opposite :: proc(d: Direction) -> Direction {
	return Direction(int(d) + 2)
}

// TODO: Count how many directions have an opposite that comes later in the
// enum (a higher number). Loop over all the directions.
count_later_opposites :: proc() -> int {
	return 0
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_opposite :: proc(t: ^testing.T) {
	testing.expect_value(t, opposite(.North), Direction.South)
	testing.expect_value(t, opposite(.East), Direction.West)
	testing.expect_value(t, opposite(.South), Direction.North)
	testing.expect_value(t, opposite(.West), Direction.East)
}

@(test)
test_count_later_opposites :: proc(t: ^testing.T) {
	testing.expect_value(t, count_later_opposites(), 2)
}
