// error_handling3
//
// A few more operators work on results that end in an `ok` bool (or an
// error value):
//
//     n := strconv.parse_int(text) or_else 0
//         // use 0 when parsing fails
//
//     for text in inputs {
//         n := strconv.parse_int(text) or_continue
//         // skips to the next input when parsing fails
//     }
//
// `or_break` works like `or_continue`, but leaves the loop.
//
// All of these "eat" the last result: `or_else 0` turns the two results of
// `parse_int` (the number and `ok`) into just a number.
package main

import "core:strconv"
import "core:testing"

// Adds up all the entries that are whole numbers and skips the others.
//
// TODO: `strconv.parse_int` returns two results: the number and whether
// parsing worked. Skip the entries that aren't numbers.
sum_numbers :: proc(entries: []string) -> int {
	total := 0
	for entry in entries {
		value := strconv.parse_int(entry)
		total += value
	}
	return total
}

// Reads a volume setting, falling back to 50 when it isn't a number.
//
// TODO: Use `or_else` to fall back to 50.
volume_setting :: proc(text: string) -> int {
	volume, _ := strconv.parse_int(text)
	return volume
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
