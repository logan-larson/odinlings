// intro1
//
// Welcome! Odinlings is a set of small programs that are broken in some way.
// Your job is to fix them. Odinlings checks the current exercise again every
// time you save its file, and shows you what the compiler or the program said.
//
// This first exercise already works. Look at the output in the terminal, then
// try changing one of the messages below and save the file to see Odinlings
// pick up the change.
//
// TODO: When you are ready for the next exercise, press `n` in the terminal.
package main

import "core:fmt"

main :: proc() {
	fmt.println("Welcome to Odinlings!")
	fmt.println()
	fmt.println("Every exercise from here on has a compiler error, a crash, a wrong")
	fmt.println("result or a failing test. Read the comments in the exercise file,")
	fmt.println("fix the problem, and save. Press `h` in the terminal for a hint.")
	fmt.println()
	fmt.println("The file of this exercise is exercises/00_intro/intro1/intro1.odin.")
	fmt.println("The path of the current exercise is always shown under the progress bar.")
}
