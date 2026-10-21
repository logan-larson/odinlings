// dynamic_arrays1
//
// The length of a fixed array must be known when the program is compiled.
// When you don't know in advance how many elements there will be, use a
// dynamic array, `[dynamic]T`. It grows as you `append` to it:
//
//     names: [dynamic]string
//     append(&names, "Ada")
//     append(&names, "Bob", "Cy")    // several at once
//     len(names)                     // 3
//
// Growing needs memory, which the dynamic array asks for (allocates) as it
// goes. Odin does not clean up memory for you: when you are done with a
// dynamic array, free its memory with `delete(names)`.
package main

import "core:testing"

// Returns the even numbers from 1 to n, in order.
//
// TODO: A fixed array's length must be a constant, but `n` is only known
// when the program runs. Return a dynamic array and use `append` instead.
evens_up_to :: proc(n: int) -> [dynamic]int {
	result: [n / 2]int
	count := 0
	for i in 1 ..= n {
		if i % 2 == 0 {
			result[count] = i
			count += 1
		}
	}
	return result
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_evens_up_to_ten :: proc(t: ^testing.T) {
	evens := evens_up_to(10)
	defer delete(evens)
	testing.expect_value(t, len(evens), 5)
	for value, i in evens {
		testing.expect_value(t, value, (i + 1) * 2)
	}
}

@(test)
test_no_evens :: proc(t: ^testing.T) {
	evens := evens_up_to(1)
	defer delete(evens)
	testing.expect_value(t, len(evens), 0)
}
