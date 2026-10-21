// variables2
package main

import "core:fmt"

main :: proc() {
	// Without a value, `score` starts at the zero value of `int`.
	score: int
	fmt.println("score starts at", score)

	// `=` assigns to the existing variable.
	score = 10
	fmt.println("score is now", score)
}
