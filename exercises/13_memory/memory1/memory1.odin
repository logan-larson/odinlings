// memory1
//
// Local variables live on the stack and disappear when their procedure
// returns. When a value has to live longer, allocate it on the heap with
// `new`. It returns a pointer to a new, zeroed value:
//
//     p := new(Player)    // p is a ^Player
//     p.name = "Ada"
//     ...
//     free(p)             // give the memory back when you are done
//
// Odin has no garbage collector, so memory stays allocated until you free
// it. Forgetting to free is called a memory leak.
//
// The tests of this exercise check for leaks: they fail if memory is not
// freed (or is freed twice).
package main

import "core:testing"

Node :: struct {
	value: int,
	next:  ^Node,
}

// Allocates a new node holding `value`.
//
// TODO: The procedure promises a pointer, but returns the node itself.
make_node :: proc(value: int) -> ^Node {
	node := new(Node)
	node.value = value
	return node^
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_make_node :: proc(t: ^testing.T) {
	first := make_node(1)
	defer free(first)
	second := make_node(2)
	defer free(second)

	first.next = second
	testing.expect_value(t, first.value, 1)
	testing.expect_value(t, first.next.value, 2)
	testing.expect(t, second.next == nil)
}
