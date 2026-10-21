// arrays1
package main

import "core:fmt"

main :: proc() {
	planets := [?]string{"Mercury", "Venus", "Earth", "Mars", "Jupiter"}

	fmt.println("There are", len(planets), "planets in the list")
	fmt.println("The first one is", planets[0])
	// Indices start at 0, so the last element is at `len(planets) - 1`.
	fmt.println("The last one is", planets[len(planets) - 1])
}
