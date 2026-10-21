// pointers2
package main

import "core:testing"

Player :: struct {
	name:  string,
	score: int,
}

// `n` itself still can't be changed, but `n^`, the int it points to, can.
increment :: proc(n: ^int) {
	n^ += 1
}

// `player.score` follows the pointer automatically.
add_bonus :: proc(player: ^Player, bonus: int) {
	player.score += bonus
}

main :: proc() {
}

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
