// slices1
//
// A slice is a view into a sequence of elements that are stored somewhere
// else, for example in an array. Its type is `[]T`. You make one by slicing
// with `[low:high]`, which includes `low` and stops before `high`:
//
//     numbers := [5]int{10, 20, 30, 40, 50}
//     middle := numbers[1:4]     // views 20, 30, 40
//     all := numbers[:]          // views the whole array
//     tail := numbers[3:]        // views 40, 50
//
// A slice doesn't copy anything. Writing through a slice changes the array
// it looks at.
package main

import "core:fmt"

main :: proc() {
	temperatures := [7]int{12, 15, 11, 9, 14, 18, 20}

	// TODO: An array isn't a slice. Make `week` view the whole array.
	week: []int = temperatures
	weekend := temperatures[5:]

	fmt.println("Days in the week:", len(week))
	fmt.println("Weekend:", weekend)

	weekend[0] = 25
	fmt.println("Saturday is now", temperatures[5])
}
