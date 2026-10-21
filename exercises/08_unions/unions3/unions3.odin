// unions3
//
// When you only care about one type, a type assertion takes it straight out
// of a union:
//
//     n: Number = 5
//     i := n.(int)            // 5
//
// If the union holds a different type, a plain assertion crashes the
// program. Ask for a second result to check instead; then nothing crashes,
// and `ok` tells you whether it worked:
//
//     f, ok := n.(f64)        // f is 0, ok is false
//
// The same works in an `if`:
//
//     if i, ok := n.(int); ok {
//         fmt.println("it's an int:", i)
//     }
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

// Returns the key that was pressed, or 0 if the event isn't a key press.
//
// TODO: This crashes when the event is a mouse click. Check the assertion.
pressed_key :: proc(event: Event) -> rune {
	press := event.(Key_Press)
	return press.key
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_key_press :: proc(t: ^testing.T) {
	testing.expect_value(t, pressed_key(Key_Press{key = 'q'}), 'q')
}

@(test)
test_mouse_click :: proc(t: ^testing.T) {
	testing.expect_value(t, pressed_key(Mouse_Click{x = 10, y = 20}), 0)
}
