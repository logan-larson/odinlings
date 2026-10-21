// pointers3
//
// The zero value of a pointer is `nil`: it points nowhere. Reading or
// writing through a nil pointer crashes the program, so code that might get
// a nil pointer has to check for it first:
//
//     if p != nil {
//         p.score += 1
//     }
//
// A procedure can also return a pointer, for example to one of the values
// it was given. The caller can then change that value through the pointer.
package main

import "core:testing"

Player :: struct {
	name:  string,
	score: int,
}

// Returns a pointer to the player with the higher score. On a tie, `a`.
//
// TODO: This always returns `a`.
leader :: proc(a, b: ^Player) -> ^Player {
	return a
}

// TODO: This crashes when `player` is nil. In that case it should do
// nothing.
add_bonus :: proc(player: ^Player, bonus: int) {
	player.score += bonus
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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

	// Changing the leader through the pointer changes `bob`.
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
