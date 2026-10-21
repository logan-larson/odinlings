// maps3
package main

import "core:fmt"
import "core:slice"

main :: proc() {
	route := [?]string{"Oslo", "Lima", "Oslo", "Kyiv", "Lima", "Oslo"}

	visited: map[string]struct{}
	defer delete(visited)
	for city in route {
		// `{}` is the (only) value of `struct{}`. Inserting a key twice
		// keeps one entry.
		visited[city] = {}
	}

	cities := make([dynamic]string, 0, len(visited))
	defer delete(cities)
	for city in visited {
		append(&cities, city)
	}
	slice.sort(cities[:])

	fmt.println("Visited", len(visited), "different cities:", cities)
}
