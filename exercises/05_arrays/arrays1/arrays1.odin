// arrays1
//
// A fixed array holds a set number of values of one type. The length is part
// of the type, and must be known when the program is compiled:
//
//     primes: [4]int = {2, 3, 5, 7}
//     vowels := [?]rune{'a', 'e', 'i', 'o', 'u'}   // [?] counts for you
//
// Elements are numbered from 0, so the last element of `primes` is
// `primes[3]`, and `len(primes)` is 4. Reading outside of an array is an
// error. When the index is a constant, the compiler catches it right away.
//
// A range loop can give you each element, and its index too:
//
//     for p, i in primes {
//         fmt.println("prime number", i, "is", p)
//     }
package main

import "core:fmt"

main :: proc() {
	planets := [?]string{"Mercury", "Venus", "Earth", "Mars", "Jupiter"}

	fmt.println("There are", len(planets), "planets in the list")
	fmt.println("The first one is", planets[0])
	// TODO: Print the last planet in the list.
	fmt.println("The last one is", planets[5])
}
