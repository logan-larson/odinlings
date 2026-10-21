// error_handling3
package main

import "core:strconv"
import "core:testing"

sum_numbers :: proc(entries: []string) -> int {
	total := 0
	for entry in entries {
		// When `ok` is false, the rest of this iteration is skipped.
		value := strconv.parse_int(entry) or_continue
		total += value
	}
	return total
}

volume_setting :: proc(text: string) -> int {
	return strconv.parse_int(text) or_else 50
}

main :: proc() {
}

@(test)
test_sum_numbers :: proc(t: ^testing.T) {
	testing.expect_value(t, sum_numbers({"10", "oops", "20", "", "12"}), 42)
	testing.expect_value(t, sum_numbers({"x", "y"}), 0)
}

@(test)
test_volume_setting :: proc(t: ^testing.T) {
	testing.expect_value(t, volume_setting("80"), 80)
	testing.expect_value(t, volume_setting("loud"), 50)
}
