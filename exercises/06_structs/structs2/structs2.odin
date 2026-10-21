// structs2
//
// A field can itself be a struct (or an array of structs):
//
//     Size :: struct { width, height: int }
//     Room :: struct { name: string, size: Size }
//
//     kitchen := Room{name = "kitchen", size = {width = 3, height = 4}}
//     kitchen.size.width     // 3
//
// Notice that the inner literal is just `{...}`: when the compiler already
// knows which type is expected, you don't have to write the type name.
//
// Odin has no methods. Code that works on a struct is an ordinary procedure
// that takes the struct as a parameter.
package main

import "core:testing"

Size :: struct {
	width:  int,
	height: int,
}

Room :: struct {
	name: string,
	size: Size,
}

House :: struct {
	rooms: [3]Room,
}

// TODO: The area of a room is its width times its height.
area :: proc(room: Room) -> int {
	return room.size.width
}

// TODO: Add up the areas of all the rooms in the house.
total_area :: proc(house: House) -> int {
	return 0
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_area :: proc(t: ^testing.T) {
	testing.expect_value(t, area({name = "hall", size = {width = 2, height = 5}}), 10)
}

@(test)
test_total_area :: proc(t: ^testing.T) {
	house := House {
		rooms = {
			{name = "kitchen", size = {3, 4}},
			{name = "bedroom", size = {4, 4}},
			{name = "bathroom", size = {2, 3}},
		},
	}
	testing.expect_value(t, total_area(house), 34)
}
