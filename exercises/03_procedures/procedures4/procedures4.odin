// procedures4
//
// Two procedures in Odin can't have the same name. When you want one name for
// several procedures, you create a "procedure group" that lists them. The
// compiler picks the procedure whose parameters fit the call:
//
//     print_int    :: proc(x: int) { ... }
//     print_string :: proc(s: string) { ... }
//     print_value  :: proc{print_int, print_string}
//
//     print_value(42)       // calls print_int
//     print_value("hi")     // calls print_string
//
// Because the group is written out by hand, you can always see exactly which
// procedures a call might use.
package main

import "core:testing"

area_of_square :: proc(side: f64) -> f64 {
	return side * side
}

area_of_rectangle :: proc(width, height: f64) -> f64 {
	return width * height
}

// TODO: `area` should also work with a width and a height.
area :: proc {
	area_of_square,
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_square :: proc(t: ^testing.T) {
	testing.expect_value(t, area(3), 9)
}

@(test)
test_rectangle :: proc(t: ^testing.T) {
	testing.expect_value(t, area(2, 5), 10)
}
