// variables1
package main

import "core:fmt"

main :: proc() {
	// `:=` declares `x` and infers its type (int) from the value.
	x := 5

	fmt.println("x has the value", x)
}
