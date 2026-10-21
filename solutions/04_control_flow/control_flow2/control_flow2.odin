// control_flow2
package main

import "core:testing"

// `..=` includes the end of the range.
sum_up_to :: proc(n: int) -> int {
	total := 0
	for i in 1 ..= n {
		total += i
	}
	return total
}

// The loop works on `x`, a local copy of the parameter.
halvings :: proc(n: int) -> int {
	count := 0
	x := n
	for x > 1 {
		x /= 2
		count += 1
	}
	return count
}

main :: proc() {
}

@(test)
test_sum_up_to :: proc(t: ^testing.T) {
	testing.expect_value(t, sum_up_to(1), 1)
	testing.expect_value(t, sum_up_to(4), 10)
	testing.expect_value(t, sum_up_to(100), 5050)
}

@(test)
test_halvings :: proc(t: ^testing.T) {
	testing.expect_value(t, halvings(1), 0)
	testing.expect_value(t, halvings(8), 3)
	testing.expect_value(t, halvings(100), 6)
}
