// unions1
//
// A union is a type that holds one value out of a list of types. It knows
// which type it holds at any moment:
//
//     Number :: union {
//         int,
//         f64,
//     }
//
//     n: Number = 5        // holds an int
//     n = 2.5              // now holds an f64
//
// To find out what is inside, use a type switch. In each case, `v` has the
// type of that case:
//
//     switch v in n {
//     case int:
//         fmt.println("an int:", v)
//     case f64:
//         fmt.println("a float:", v)
//     }
//
// Like a switch over an enum, a type switch must handle every type in the
// union.
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

// TODO: Handle the shape that is missing. The area of a triangle is half of
// its base times its height.
area :: proc(shape: Shape) -> f64 {
	switch s in shape {
	case Square:
		return s.side * s.side
	case Rectangle:
		return s.width * s.height
	}
	return 0
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_area :: proc(t: ^testing.T) {
	testing.expect_value(t, area(Square{side = 3}), 9)
	testing.expect_value(t, area(Rectangle{width = 2, height = 5}), 10)
	testing.expect_value(t, area(Triangle{base = 4, height = 3}), 6)
}
