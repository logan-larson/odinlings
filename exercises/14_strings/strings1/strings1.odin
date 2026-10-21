// strings1
//
// A string is a sequence of bytes, encoded as UTF-8. Letters from the
// English alphabet take one byte each, but many other characters take two to
// four bytes:
//
//     len("cat")     // 3
//     len("café")    // 5: the é takes two bytes
//
// A `for` loop over a string decodes it and gives you one rune (character)
// at a time, together with the byte position where the rune starts:
//
//     for r, i in "café" {
//         fmt.println(i, r)   // 0 c, 1 a, 2 f, 3 é
//     }
package main

import "core:testing"

// TODO: Count characters (runes), not bytes.
count_runes :: proc(s: string) -> int {
	return len(s)
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_ascii :: proc(t: ^testing.T) {
	testing.expect_value(t, count_runes("hello"), 5)
	testing.expect_value(t, count_runes(""), 0)
}

@(test)
test_unicode :: proc(t: ^testing.T) {
	testing.expect_value(t, count_runes("héllo"), 5)
	testing.expect_value(t, count_runes("日本語"), 3)
	testing.expect_value(t, count_runes("Odin ❤"), 6)
}
