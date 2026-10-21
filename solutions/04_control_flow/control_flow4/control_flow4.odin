// control_flow4
package main

import "core:fmt"

main :: proc() {
	tries := 0
	search: for a in 1 ..= 9 {
		for b in 1 ..= 9 {
			tries += 1
			if a * b == 24 {
				fmt.println("Found", a, "*", b, "= 24")
				// `break search` leaves both loops at once.
				break search
			}
		}
	}
	fmt.println("Tries:", tries)
}
