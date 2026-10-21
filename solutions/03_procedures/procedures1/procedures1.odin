// procedures1
package main

import "core:fmt"

// `-> int` declares that the procedure returns an int.
add :: proc(a, b: int) -> int {
	return a + b
}

main :: proc() {
	fmt.println("2 + 3 =", add(2, 3))
}
