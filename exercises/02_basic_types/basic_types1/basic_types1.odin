// basic_types1
//
// Odin has integer types of fixed sizes: i8, i16, i32 and i64 are signed,
// u8, u16, u32 and u64 are unsigned. `int` and `uint` have the size of a
// pointer, which is 64 bits on most machines.
//
// Odin never converts between number types behind your back. To combine two
// different types, convert one of them yourself by "calling" the type:
//
//     small: i32 = 10
//     big := i64(small)
//
// Underscores in number literals are ignored, so 1_000_000 is one million.
package main

import "core:fmt"

main :: proc() {
	apples: i32 = 120
	grains_of_rice: i64 = 30_000_000_000

	// TODO: Make the types match so the two can be added.
	total := apples + grains_of_rice

	fmt.println("Total:", total)
}
