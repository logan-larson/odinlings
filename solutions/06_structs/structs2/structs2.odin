// structs2
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

area :: proc(room: Room) -> int {
	return room.size.width * room.size.height
}

total_area :: proc(house: House) -> int {
	total := 0
	for room in house.rooms {
		total += area(room)
	}
	return total
}

main :: proc() {
}

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
