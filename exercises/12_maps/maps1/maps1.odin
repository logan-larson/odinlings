// maps1
//
// A map stores values under keys. `map[string]int` maps strings to ints:
//
//     ages := make(map[string]int)
//     defer delete(ages)
//
//     ages["Ada"] = 36            // insert or overwrite
//     ages["Ada"] += 1            // update
//     fmt.println(ages["Ada"])    // 37
//     fmt.println(ages["Zed"])    // 0: a missing key gives the zero value
//     fmt.println(len(ages))      // 1
//
// Like a dynamic array, a map allocates memory as it grows. Free it with
// `delete` when you are done with it.
package main

import "core:testing"

// Counts how often each word appears.
//
// TODO: Every word is counted as 1, even when it appears several times.
count_words :: proc(words: []string) -> map[string]int {
	counts := make(map[string]int)
	for word in words {
		counts[word] = 1
	}
	return counts
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_count_words :: proc(t: ^testing.T) {
	counts := count_words({"the", "cat", "and", "the", "hat", "the", "end"})
	defer delete(counts)

	testing.expect_value(t, len(counts), 5)
	testing.expect_value(t, counts["the"], 3)
	testing.expect_value(t, counts["cat"], 1)
	testing.expect_value(t, counts["dog"], 0)
}
