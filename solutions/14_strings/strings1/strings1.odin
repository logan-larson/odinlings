// strings1
package main

import "core:testing"

// Looping over a string visits each rune once, however many bytes it takes.
// `utf8.rune_count_in_string` from "core:unicode/utf8" does the same job.
count_runes :: proc(s: string) -> int {
	count := 0
	for _ in s {
		count += 1
	}
	return count
}

main :: proc() {
}

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
