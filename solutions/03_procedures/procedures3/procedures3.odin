// procedures3
package main

import "core:testing"

// `multiplier := 1` gives the parameter a default value (and the type int).
xp_for_level :: proc(level: int, multiplier := 1) -> int {
	return level * 100 * multiplier
}

main :: proc() {
}

@(test)
test_default_multiplier :: proc(t: ^testing.T) {
	testing.expect_value(t, xp_for_level(3), 300)
}

@(test)
test_named_arguments :: proc(t: ^testing.T) {
	testing.expect_value(t, xp_for_level(multiplier = 3, level = 2), 600)
}
