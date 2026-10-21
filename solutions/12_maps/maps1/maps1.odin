// maps1
package main

import "core:testing"

// A missing key reads as 0, so `+= 1` works for the first occurrence too.
count_words :: proc(words: []string) -> map[string]int {
	counts := make(map[string]int)
	for word in words {
		counts[word] += 1
	}
	return counts
}

main :: proc() {
}

@(test)
test_count_words :: proc(t: ^testing.T) {
	counts := count_words({"the", "cat", "and", "the", "hat", "the", "end"})
	defer delete(counts)

	testing.expect_value(t, len(counts), 5)
	testing.expect_value(t, counts["the"], 3)
	testing.expect_value(t, counts["cat"], 1)
	testing.expect_value(t, counts["dog"], 0)
}
