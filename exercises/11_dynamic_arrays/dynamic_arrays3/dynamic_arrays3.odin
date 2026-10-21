// dynamic_arrays3
//
// Every time a dynamic array runs out of room, `append` allocates a bigger
// block of memory and copies the elements over. `cap(arr)` tells you how many
// elements fit before that happens. If you know roughly how many elements
// you'll add, make room up front:
//
//     arr := make([dynamic]int, 0, 100)   // length 0, room for 100
//     defer delete(arr)
//
// `defer delete(arr)` right after creating the array is a common pattern:
// the memory is freed at the end of the scope, however the scope ends.
//
// As with slices, use `for &x in arr` to change the elements in a loop.
package main

import "core:fmt"

main :: proc() {
	stock := make([dynamic]int, 0, 8)
	defer delete(stock)
	append(&stock, 3, 0, 7)

	// TODO: A delivery arrived: add 10 to every item in stock.
	for count in stock {
		count += 10
	}

	fmt.println("Stock:", stock)
	fmt.println("Length:", len(stock), "Capacity:", cap(stock))
}
