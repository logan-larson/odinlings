// unions1
package main

import "core:testing"

Square :: struct {
	side: f64,
}

Rectangle :: struct {
	width:  f64,
	height: f64,
}

Triangle :: struct {
	base:   f64,
	height: f64,
}

Shape :: union {
	Square,
	Rectangle,
	Triangle,
}

// Inside each case, `s` has the type of that case.
area :: proc(shape: Shape) -> f64 {
	switch s in shape {
	case Square:
		return s.side * s.side
	case Rectangle:
		return s.width * s.height
	case Triangle:
		return s.base * s.height / 2
	}
	// A union can also be empty (nil), which the switch above doesn't cover.
	return 0
}

main :: proc() {
}

@(test)
test_area :: proc(t: ^testing.T) {
	testing.expect_value(t, area(Square{side = 3}), 9)
	testing.expect_value(t, area(Rectangle{width = 2, height = 5}), 10)
	testing.expect_value(t, area(Triangle{base = 4, height = 3}), 6)
}
