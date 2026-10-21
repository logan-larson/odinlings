// variables2
//
// You can also give a variable an explicit type: `name: Type = value`. If you
// leave out the value, the variable starts at its type's "zero value": 0 for
// numbers, false for booleans and "" for strings.
//
//     lives: int     // declares `lives`; it starts at 0
//     lives = 3      // assigns to the existing `lives`
//
// A name can only be declared once in the same scope.
package main

import "core:fmt"

main :: proc() {
	score: int
	fmt.println("score starts at", score)

	// TODO: `score` already exists. Give it a new value instead of declaring
	// it a second time.
	score := 10
	fmt.println("score is now", score)
}
