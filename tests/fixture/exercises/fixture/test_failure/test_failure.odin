package main

import "core:testing"

main :: proc() {}

@(test)
fails :: proc(t: ^testing.T) {
	testing.expect_value(t, 6 * 9, 42)
}
