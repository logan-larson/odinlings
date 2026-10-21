// control_flow5
package main

import "core:fmt"

main :: proc() {
	fmt.println("Opening the bakery")
	// Runs when `main` returns.
	defer fmt.println("Closing the bakery")

	fmt.println("Serving customers")
	{
		fmt.println("  Baking bread")
		// Runs at the closing brace of this block.
		defer fmt.println("  Cleaning the oven")
		fmt.println("  Selling bread")
	}
	fmt.println("Counting the money")
}
