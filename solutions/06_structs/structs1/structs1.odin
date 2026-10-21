// structs1
package main

import "core:fmt"

Point :: struct {
	x: int,
	y: int,
}

main :: proc() {
	home := Point{x = 2, y = 5}
	// `y` is left out, so it is 0.
	shop := Point{x = 7}

	fmt.println("Home is at", home.x, home.y)
	fmt.println("The shop is at", shop.x, shop.y)
	fmt.println("Walking distance:", abs(shop.x - home.x) + abs(shop.y - home.y))
}
