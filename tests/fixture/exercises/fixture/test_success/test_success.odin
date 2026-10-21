package main

import "core:testing"

main :: proc() {}

@(test)
passes :: proc(t: ^testing.T) {
	testing.expect_value(t, 2 + 2, 4)
}
