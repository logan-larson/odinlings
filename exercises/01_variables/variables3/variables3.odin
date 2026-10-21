// variables3
//
// Values that never change can be constants, declared with `::` instead of
// `:=`:
//
//     MAX_PLAYERS :: 4
//
// A constant is known when the program is compiled and can never be assigned
// to. By convention, constant names are written in SCREAMING_SNAKE_CASE.
//
// Odinlings compiles every exercise with the `-vet-unused` flag. It turns a
// variable that is declared but never used into an error, because that is
// usually a mistake or leftover code.
package main

import "core:fmt"

DAYS_PER_WEEK :: 7

main :: proc() {
	weeks := 3
	// TODO: There are two problems in the next two lines. The compiler points
	// at both of them.
	DAYS_PER_WEEK = 5
	leftover := 2

	fmt.println(weeks, "weeks have", weeks * DAYS_PER_WEEK, "days")
}
