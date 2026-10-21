// arrays2
//
// Odin can do arithmetic on whole arrays at once. Adding two arrays adds
// their elements pairwise, and an operation with a single number applies to
// every element:
//
//     a := [3]f32{1, 2, 3}
//     b := [3]f32{10, 20, 30}
//     a + b      // {11, 22, 33}
//     a * 2      // {2, 4, 6}
//
// Arrays with up to four elements also have named fields: `.x`, `.y`, `.z`
// and `.w` (or `.r`, `.g`, `.b`, `.a`). You can even combine them, which is
// called swizzling: `a.zyx` is `{3, 2, 1}`.
//
// This makes small arrays a handy type for positions and directions.
package main

import "core:testing"

Vec2 :: [2]f32

// TODO: The midpoint between two points is their average, but this returns
// something else. Remember that `/` is done before `+`.
midpoint :: proc(a, b: Vec2) -> Vec2 {
	return a + b / 2
}

// TODO: Return the vector with its x and y swapped.
swapped :: proc(v: Vec2) -> Vec2 {
	return v
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_midpoint :: proc(t: ^testing.T) {
	testing.expect_value(t, midpoint({0, 0}, {4, 2}), Vec2{2, 1})
	testing.expect_value(t, midpoint({-1, 3}, {3, 3}), Vec2{1, 3})
}

@(test)
test_swapped :: proc(t: ^testing.T) {
	testing.expect_value(t, swapped({1, 2}), Vec2{2, 1})
}
