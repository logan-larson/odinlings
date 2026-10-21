// procedures1
//
// Procedures are declared with `::`, just like constants:
//
//     square :: proc(x: int) -> int {
//         return x * x
//     }
//
// Parameters are written `name: Type`. When several parameters in a row
// share a type, you can write the type once: `proc(a, b: int)`. The type
// after `->` is the type of the value the procedure returns.
package main

import "core:fmt"

// TODO: This procedure returns a value, but its signature doesn't say so.
add :: proc(a, b: int) {
	return a + b
}

main :: proc() {
	fmt.println("2 + 3 =", add(2, 3))
}
