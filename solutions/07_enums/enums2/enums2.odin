// enums2
package main

import "core:testing"

Direction :: enum {
	North,
	East,
	South,
	West,
}

// `% len(Direction)` wraps 4 back to 0 and 5 back to 1.
opposite :: proc(d: Direction) -> Direction {
	return Direction((int(d) + 2) % len(Direction))
}

count_later_opposites :: proc() -> int {
	count := 0
	for d in Direction {
		if int(opposite(d)) > int(d) {
			count += 1
		}
	}
	return count
}

main :: proc() {
}

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
