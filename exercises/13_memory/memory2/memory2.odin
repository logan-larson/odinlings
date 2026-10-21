// memory2
//
// Every allocation needs a matching free:
//
//     new(T)                 ->  free(p)
//     make([]T, n)           ->  delete(s)
//     make([dynamic]T)       ->  delete(arr)
//     make(map[K]V)          ->  delete(m)
//     append to a [dynamic]  ->  delete(arr)
//
// When memory is only needed inside one procedure, free it at the end of
// that procedure. `defer` right after the allocation makes sure it happens.
//
// The tests in this exercise fail when memory leaks. Odin's test runner
// shows where the leaked memory was allocated.
package main

import "core:testing"

// Returns the sum of the squares of the even numbers.
//
// TODO: This gives the right answer, but leaks memory every time it is
// called. Free the memory before returning.
sum_of_even_squares :: proc(numbers: []int) -> int {
	evens := make([dynamic]int)
	for n in numbers {
		if n % 2 == 0 {
			append(&evens, n)
		}
	}

	total := 0
	for e in evens {
		total += e * e
	}
	return total
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_sum_of_even_squares :: proc(t: ^testing.T) {
	testing.expect_value(t, sum_of_even_squares({1, 2, 3, 4}), 20)
	testing.expect_value(t, sum_of_even_squares({5, 7}), 0)
}
