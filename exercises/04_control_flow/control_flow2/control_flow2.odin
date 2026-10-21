// control_flow2
//
// `for` is Odin's only loop keyword. It comes in several shapes:
//
//     for i := 0; i < 10; i += 1 { }    // like C's for loop
//     for x < 100 { }                    // like "while" in other languages
//     for { }                            // loops forever (until `break`)
//
// To count through a range of numbers, use a range loop:
//
//     for i in 0 ..< 5 { }    // 0, 1, 2, 3, 4      `..<` excludes the end
//     for i in 1 ..= 5 { }    // 1, 2, 3, 4, 5      `..=` includes the end
//
// One more rule that matters here: procedure parameters can't be assigned
// to. To change a value you got as a parameter, copy it into a local
// variable first.
package main

import "core:testing"

// TODO: `sum_up_to(n)` should add up all the numbers from 1 to n, including
// n. Right now it misses one.
sum_up_to :: proc(n: int) -> int {
	total := 0
	for i in 1 ..< n {
		total += i
	}
	return total
}

// `halvings(n)` counts how many times n can be divided by 2 (rounding down)
// before it reaches 1.
//
// TODO: The compiler doesn't allow changing `n`. Work on a copy instead.
halvings :: proc(n: int) -> int {
	count := 0
	for n > 1 {
		n /= 2
		count += 1
	}
	return count
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
