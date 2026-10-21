// pointers1
//
// A pointer holds the address of a value in memory. `^T` is the type
// "pointer to a T". `&x` gives you the address of `x`, and `p^` reaches the
// value that `p` points to, for reading or for writing:
//
//     n := 10
//     p: ^int = &n
//     p^ = 20          // n is now 20
//     fmt.println(p^)  // 20
package main

import "core:fmt"

main :: proc() {
	lives := 3
	// TODO: `p` should point to `lives`.
	p: ^int = lives

	p^ -= 1
	fmt.println("Lives left:", lives)
	fmt.println("Read through the pointer:", p^)
}
