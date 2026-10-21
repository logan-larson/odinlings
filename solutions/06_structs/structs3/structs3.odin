// structs3
package main

import "core:testing"

Vec2 :: struct {
	x: f32,
	y: f32,
}

// With `using`, `e.x` means `e.position.x`.
Entity :: struct {
	name:           string,
	using position: Vec2,
}

moved :: proc(e: Entity, dx, dy: f32) -> Entity {
	result := e
	result.x += dx
	result.y += dy
	return result
}

main :: proc() {
}

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
