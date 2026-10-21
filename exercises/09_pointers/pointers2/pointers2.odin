// pointers2
//
// Procedure parameters are copies, and they can't be assigned to. When a
// procedure should change the caller's variable, pass a pointer to it:
//
//     reset :: proc(n: ^int) {
//         n^ = 0
//     }
//
//     score := 50
//     reset(&score)    // score is now 0
//
// When the pointer points to a struct, you can reach its fields with a
// plain dot. Odin follows the pointer for you:
//
//     p: ^Player = &player
//     p.score += 1     // the same as p^.score += 1
package main

import "core:testing"

Player :: struct {
	name:  string,
	score: int,
}

// TODO: `increment` should change the caller's variable.
increment :: proc(n: int) {
	n += 1
}

// TODO: Give the player the bonus points, so that the change is visible to
// the caller.
add_bonus :: proc(player: Player, bonus: int) {
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_increment :: proc(t: ^testing.T) {
	x := 41
	increment(&x)
	testing.expect_value(t, x, 42)
}

@(test)
test_add_bonus :: proc(t: ^testing.T) {
	ada := Player {
		name  = "Ada",
		score = 10,
	}
	add_bonus(&ada, 5)
	testing.expect_value(t, ada.score, 15)
}
