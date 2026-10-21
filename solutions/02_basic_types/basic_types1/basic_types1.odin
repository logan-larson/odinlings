// basic_types1
package main

import "core:fmt"

main :: proc() {
	apples: i32 = 120
	grains_of_rice: i64 = 30_000_000_000

	// Converting the smaller type to the bigger one can't lose information.
	// Converting the other way (i32(grains_of_rice)) would compile too, but
	// the value doesn't fit in 32 bits and would come out wrong.
	total := i64(apples) + grains_of_rice

	fmt.println("Total:", total)
}
