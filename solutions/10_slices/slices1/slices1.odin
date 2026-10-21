// slices1
package main

import "core:fmt"

main :: proc() {
	temperatures := [7]int{12, 15, 11, 9, 14, 18, 20}

	// `[:]` slices the whole array.
	week: []int = temperatures[:]
	weekend := temperatures[5:]

	fmt.println("Days in the week:", len(week))
	fmt.println("Weekend:", weekend)

	// `weekend` looks at the same memory as `temperatures`.
	weekend[0] = 25
	fmt.println("Saturday is now", temperatures[5])
}
