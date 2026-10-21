// variables3
package main

import "core:fmt"

// A constant can't be assigned to, so the assignment was removed. The unused
// variable `leftover` was removed as well.
DAYS_PER_WEEK :: 7

main :: proc() {
	weeks := 3
	fmt.println(weeks, "weeks have", weeks * DAYS_PER_WEEK, "days")
}
