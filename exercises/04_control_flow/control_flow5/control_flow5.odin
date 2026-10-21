// control_flow5
//
// `defer` schedules a statement to run when the current scope ends, however
// it ends. That makes it great for cleanup: write the cleanup right next to
// the setup, and it happens automatically at the end.
//
//     open_door()
//     defer close_door()
//     // ... close_door() runs after everything in this scope
//
// A scope is the code between a pair of braces `{ }`. When a scope contains
// several `defer`s, they run in reverse order: the last one runs first.
package main

import "core:fmt"

main :: proc() {
	fmt.println("Opening the bakery")
	// TODO: The bakery must close only after all the work is done. Use
	// `defer` so that this line runs last, without moving it.
	fmt.println("Closing the bakery")

	fmt.println("Serving customers")
	{
		fmt.println("  Baking bread")
		// TODO: Same here: cleaning must wait until the baking and selling
		// are done.
		fmt.println("  Cleaning the oven")
		fmt.println("  Selling bread")
	}
	fmt.println("Counting the money")
}
