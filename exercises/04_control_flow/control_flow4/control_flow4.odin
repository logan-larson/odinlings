// control_flow4
//
// `break` leaves the innermost loop, and `continue` jumps to the next round
// of the innermost loop. With nested loops you sometimes want to leave the
// outer loop from inside the inner one. Give the outer loop a label, and
// break out of it by name:
//
//     rows: for y in 0 ..< 10 {
//         for x in 0 ..< 10 {
//             if x * y > 20 {
//                 break rows
//             }
//         }
//     }
//
// `continue rows` works the same way.
package main

import "core:fmt"

main :: proc() {
	// Find the first pair of numbers from 1 to 9 whose product is 24, and
	// count how many pairs were tried.
	tries := 0
	search: for a in 1 ..= 9 {
		for b in 1 ..= 9 {
			tries += 1
			if a * b == 24 {
				fmt.println("Found", a, "*", b, "= 24")
				// TODO: Stop the whole search here, not just the inner loop.
				break
			}
		}
	}
	fmt.println("Tries:", tries)
}
