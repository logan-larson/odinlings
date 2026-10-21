// maps2
package main

import "core:testing"

// `in` checks for the key itself, whatever value is stored.
is_known :: proc(stock: map[string]int, item: string) -> bool {
	return item in stock
}

// With a pointer, `stock[item]` and `delete_key` change the caller's map.
take_one :: proc(stock: ^map[string]int, item: string) {
	stock[item] -= 1
	if stock[item] <= 0 {
		delete_key(stock, item)
	}
}

main :: proc() {
}

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
