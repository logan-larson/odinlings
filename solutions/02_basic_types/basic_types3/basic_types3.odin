// basic_types3
package main

import "core:fmt"

main :: proc() {
	// Single quotes make a rune, double quotes make a string.
	initial: rune = 'O'
	// Booleans are `true` or `false`, never numbers.
	is_fun: bool = true
	language := "Odin"

	fmt.println(initial, "is for", language)
	fmt.println("Is it fun?", is_fun)
	fmt.println(language, "has", len(language), "letters")
}
