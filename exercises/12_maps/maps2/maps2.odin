// maps2
//
// Because a missing key reads as the zero value, `m[key] == 0` can't tell
// a missing key from a stored 0. There are two ways to ask whether a key is
// really there:
//
//     count, ok := stock["rope"]   // ok is false if "rope" isn't a key
//     if "rope" in stock { ... }
//
// `delete_key(&m, key)` removes a key. Changing a map (inserting, updating
// or removing keys) through a parameter needs a pointer to the map, just
// like with dynamic arrays.
package main

import "core:testing"

// Returns whether the shop sells `item` at all, even if it is sold out.
//
// TODO: Items that are sold out (a count of 0) are wrongly reported as
// unknown.
is_known :: proc(stock: map[string]int, item: string) -> bool {
	return stock[item] != 0
}

// Takes one `item` out of stock. When the last one is gone, the item is
// removed from the map completely.
//
// TODO: The compiler won't let this procedure change the map. Make `stock`
// a pointer.
take_one :: proc(stock: map[string]int, item: string) {
	stock[item] -= 1
	if stock[item] <= 0 {
		delete_key(&stock, item)
	}
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_is_known :: proc(t: ^testing.T) {
	stock := make(map[string]int)
	defer delete(stock)
	stock["rope"] = 2
	stock["lamp oil"] = 0

	testing.expect(t, is_known(stock, "rope"))
	testing.expect(t, is_known(stock, "lamp oil"), "lamp oil is sold out, but it is known")
	testing.expect(t, !is_known(stock, "bombs"))
}

@(test)
test_take_one :: proc(t: ^testing.T) {
	stock := make(map[string]int)
	defer delete(stock)
	stock["rope"] = 2

	take_one(&stock, "rope")
	testing.expect_value(t, stock["rope"], 1)
	take_one(&stock, "rope")
	testing.expect(t, !("rope" in stock), "rope should be removed from the map")
}
