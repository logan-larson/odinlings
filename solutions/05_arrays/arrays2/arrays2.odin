// arrays2
package main

import "core:testing"

Vec2 :: [2]f32

// The parentheses make the addition happen first; the division then applies
// to both elements.
midpoint :: proc(a, b: Vec2) -> Vec2 {
	return (a + b) / 2
}

// A swizzle builds a new array from the fields in the order you list them.
swapped :: proc(v: Vec2) -> Vec2 {
	return v.yx
}

main :: proc() {
}

@(test)
test_midpoint :: proc(t: ^testing.T) {
	testing.expect_value(t, midpoint({0, 0}, {4, 2}), Vec2{2, 1})
	testing.expect_value(t, midpoint({-1, 3}, {3, 3}), Vec2{1, 3})
}

@(test)
test_swapped :: proc(t: ^testing.T) {
	testing.expect_value(t, swapped({1, 2}), Vec2{2, 1})
}
