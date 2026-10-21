// pointers1
package main

import "core:fmt"

main :: proc() {
	lives := 3
	// `&lives` is the address of `lives`.
	p: ^int = &lives

	// Changing `p^` changes `lives`, because they are the same memory.
	p^ -= 1
	fmt.println("Lives left:", lives)
	fmt.println("Read through the pointer:", p^)
}
