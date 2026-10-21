// structs3
//
// Putting `using` in front of a struct field makes the field's own fields
// reachable directly:
//
//     Vec2 :: struct { x, y: f32 }
//
//     Player :: struct {
//         name: string,
//         using position: Vec2,
//     }
//
//     p: Player
//     p.x = 10           // the same as p.position.x = 10
//     p.position.y = 5   // the long way still works
//
// This is a simple way to build a type out of smaller ones.
package main

import "core:testing"

Vec2 :: struct {
	x: f32,
	y: f32,
}

// TODO: The tests read `e.x` and `e.y` directly. Make that possible.
Entity :: struct {
	name:     string,
	position: Vec2,
}

// Returns a copy of the entity moved by (dx, dy).
moved :: proc(e: Entity, dx, dy: f32) -> Entity {
	result := e
	result.position.x += dx
	result.position.y += dy
	return result
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_fields :: proc(t: ^testing.T) {
	e := Entity {
		name = "rock",
	}
	e.x = 3
	e.y = 4
	testing.expect_value(t, e.position, Vec2{3, 4})
}

@(test)
test_moved :: proc(t: ^testing.T) {
	ship := Entity {
		name     = "ship",
		position = {1, 1},
	}
	ship = moved(ship, 2, -1)
	testing.expect_value(t, ship.x, 3)
	testing.expect_value(t, ship.y, 0)
}
