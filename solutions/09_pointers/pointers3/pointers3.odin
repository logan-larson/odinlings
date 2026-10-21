// pointers3
package main

import "core:testing"

Player :: struct {
	name:  string,
	score: int,
}

leader :: proc(a, b: ^Player) -> ^Player {
	if b.score > a.score {
		return b
	}
	return a
}

add_bonus :: proc(player: ^Player, bonus: int) {
	if player == nil {
		return
	}
	player.score += bonus
}

main :: proc() {
}

@(test)
test_leader :: proc(t: ^testing.T) {
	ada := Player {
		name  = "Ada",
		score = 3,
	}
	bob := Player {
		name  = "Bob",
		score = 8,
	}
	testing.expect(t, leader(&ada, &bob) == &bob)

	leader(&ada, &bob).score += 1
	testing.expect_value(t, bob.score, 9)
}

@(test)
test_nil_player :: proc(t: ^testing.T) {
	ada := Player {
		name  = "Ada",
		score = 3,
	}
	add_bonus(&ada, 2)
	testing.expect_value(t, ada.score, 5)
	add_bonus(nil, 2)
}
