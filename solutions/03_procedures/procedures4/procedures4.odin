// procedures4
package main

import "core:testing"

area_of_square :: proc(side: f64) -> f64 {
	return side * side
}

area_of_rectangle :: proc(width, height: f64) -> f64 {
	return width * height
}

// With both procedures in the group, `area(3)` picks `area_of_square` and
// `area(2, 5)` picks `area_of_rectangle`.
area :: proc {
	area_of_square,
	area_of_rectangle,
}

main :: proc() {
}

@(test)
test_square :: proc(t: ^testing.T) {
	testing.expect_value(t, area(3), 9)
}

@(test)
test_rectangle :: proc(t: ^testing.T) {
	testing.expect_value(t, area(2, 5), 10)
}
