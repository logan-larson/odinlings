// intro2
//
// Odin programs are made of packages. A package is simply a directory of
// `.odin` files, and every file starts by saying which package it belongs to.
// A program's entry point is the procedure called `main`.
//
// Odin comes with a "core" library of packages. To print text we use the
// `fmt` package, but a package must be imported before it can be used:
//
//     import "core:os"
//
// This program is supposed to print "Hellope, Odinlings!" (yes, "Hellope" is
// the traditional Odin greeting). The compiler complains, though.
package main

// TODO: Import the package that `fmt.println` comes from.

main :: proc() {
	fmt.println("Hellope, Odinlings!")
}
