// basic_types3
//
// A few more basic types:
//
//     bool     true or false. In Odin, numbers are not booleans.
//     rune     one Unicode character, written in single quotes: 'a'
//     string   text, written in double quotes: "hello"
//
// `len(s)` gives the length of a string in bytes.
package main

import "core:fmt"

main :: proc() {
	// TODO: Fix the two declarations below so each value matches its type.
	initial: rune = "O"
	is_fun: bool = 1
	language := "Odin"

	fmt.println(initial, "is for", language)
	fmt.println("Is it fun?", is_fun)
	fmt.println(language, "has", len(language), "letters")
}
