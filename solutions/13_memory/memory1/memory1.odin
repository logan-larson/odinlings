// memory1
package main

import "core:testing"

Node :: struct {
	value: int,
	next:  ^Node,
}

// `node` is already a ^Node. The node it points to lives on the heap, so it
// stays valid after this procedure returns, until the caller frees it.
make_node :: proc(value: int) -> ^Node {
	node := new(Node)
	node.value = value
	return node
}

main :: proc() {
}

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
