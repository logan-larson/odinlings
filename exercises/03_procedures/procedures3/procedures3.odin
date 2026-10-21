// procedures3
//
// A parameter can have a default value. Callers may then leave it out:
//
//     repeat :: proc(word: string, times := 2) { ... }
//     repeat("hi")         // times is 2
//     repeat("hi", 5)
//
// Note that a parameter with a default value is written `name := value`,
// and its type is inferred from the value. You can also spell out the type:
// `times: int = 2`.
//
// Any argument can be passed by name. Named arguments make calls easier to
// read, and they can come in any order:
//
//     repeat(times = 3, word = "hey")
package main

import "core:testing"

// TODO: Give `multiplier` a default value of 1, so that the tests compile.
xp_for_level :: proc(level: int, multiplier: int) -> int {
	return level * 100 * multiplier
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_default_multiplier :: proc(t: ^testing.T) {
	testing.expect_value(t, xp_for_level(3), 300)
}

@(test)
test_named_arguments :: proc(t: ^testing.T) {
	testing.expect_value(t, xp_for_level(multiplier = 3, level = 2), 600)
}
