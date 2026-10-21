// unions3
package main

import "core:testing"

Key_Press :: struct {
	key: rune,
}

Mouse_Click :: struct {
	x, y: int,
}

Event :: union {
	Key_Press,
	Mouse_Click,
}

// With two results, the assertion can't crash.
pressed_key :: proc(event: Event) -> rune {
	if press, ok := event.(Key_Press); ok {
		return press.key
	}
	return 0
}

main :: proc() {
}

@(test)
test_key_press :: proc(t: ^testing.T) {
	testing.expect_value(t, pressed_key(Key_Press{key = 'q'}), 'q')
}

@(test)
test_mouse_click :: proc(t: ^testing.T) {
	testing.expect_value(t, pressed_key(Mouse_Click{x = 10, y = 20}), 0)
}
