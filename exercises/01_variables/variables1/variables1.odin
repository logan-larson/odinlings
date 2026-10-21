// variables1
//
// In Odin you declare a new variable with `name := value`. The compiler works
// out the variable's type from the value. Plain `=` only gives a new value to
// a variable that already exists.
package main

import "core:fmt"

main :: proc() {
	// TODO: This line should declare a new variable, not assign to one.
	x = 5

	fmt.println("x has the value", x)
}
