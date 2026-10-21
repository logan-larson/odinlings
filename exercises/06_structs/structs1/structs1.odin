// structs1
//
// A struct bundles several named values (its fields) into one new type:
//
//     Book :: struct {
//         title: string,
//         pages: int,
//     }
//
// Type names are written in Ada_Case by convention. A struct literal can
// name its fields, and any field you leave out gets its zero value:
//
//     b := Book{title = "The Hobbit", pages = 310}
//     empty := Book{}                  // title is "", pages is 0
//
// Fields are read and written with a dot: `b.pages += 1`.
package main

import "core:fmt"

// TODO: Points on this map have a `y` coordinate as well. Add the field.
Point :: struct {
	x: int,
}

main :: proc() {
	home := Point{x = 2, y = 5}
	shop := Point{x = 7}

	fmt.println("Home is at", home.x, home.y)
	fmt.println("The shop is at", shop.x, shop.y)
	fmt.println("Walking distance:", abs(shop.x - home.x) + abs(shop.y - home.y))
}
