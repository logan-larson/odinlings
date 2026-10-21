// dynamic_arrays3
package main

import "core:fmt"

main :: proc() {
	stock := make([dynamic]int, 0, 8)
	defer delete(stock)
	append(&stock, 3, 0, 7)

	// `&count` refers to the element in the array, not to a copy.
	for &count in stock {
		count += 10
	}

	fmt.println("Stock:", stock)
	fmt.println("Length:", len(stock), "Capacity:", cap(stock))
}
