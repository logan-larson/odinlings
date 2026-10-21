// maps3
//
// When you only care whether a key is present, not about a value, use a map
// whose value type is the empty struct, `struct{}`. It takes no space, and
// `{}` is its only value:
//
//     seen: map[string]struct{}
//     seen["Ada"] = {}
//     if "Ada" in seen { ... }
//
// A map declared without `make` starts empty and allocates on the first
// insert; it still needs a `delete`.
//
// Looping over a map visits every key and value, but in no particular order.
// To get a stable order, copy the keys into a dynamic array and sort them
// with `slice.sort` from "core:slice".
package main

import "core:fmt"
import "core:slice"

main :: proc() {
	route := [?]string{"Oslo", "Lima", "Oslo", "Kyiv", "Lima", "Oslo"}

	visited: map[string]struct{}
	defer delete(visited)
	for city in route {
		// TODO: The set's values are empty structs, not booleans.
		visited[city] = true
	}

	cities := make([dynamic]string, 0, len(visited))
	defer delete(cities)
	for city in visited {
		append(&cities, city)
	}
	slice.sort(cities[:])

	fmt.println("Visited", len(visited), "different cities:", cities)
}
