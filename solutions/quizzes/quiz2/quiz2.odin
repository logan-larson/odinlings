// quiz2
package main

import "core:testing"

Kind :: enum {
	Food,
	Tool,
	Treasure,
}

Item :: struct {
	name:  string,
	kind:  Kind,
	count: int,
}

Inventory :: [4]Item

count_of_kind :: proc(inventory: Inventory, kind: Kind) -> int {
	total := 0
	for item in inventory {
		if item.kind == kind {
			total += item.count
		}
	}
	return total
}

find_item :: proc(inventory: Inventory, name: string) -> Maybe(Item) {
	for item in inventory {
		if item.name == name {
			return item
		}
	}
	return nil
}

main :: proc() {
}

INVENTORY :: Inventory {
	{name = "apple", kind = .Food, count = 3},
	{name = "rope", kind = .Tool, count = 1},
	{name = "gold coin", kind = .Treasure, count = 12},
	{name = "bread", kind = .Food, count = 2},
}

@(test)
test_count_of_kind :: proc(t: ^testing.T) {
	testing.expect_value(t, count_of_kind(INVENTORY, .Food), 5)
	testing.expect_value(t, count_of_kind(INVENTORY, .Tool), 1)
	testing.expect_value(t, count_of_kind(INVENTORY, .Treasure), 12)
}

@(test)
test_find_item :: proc(t: ^testing.T) {
	rope, found := find_item(INVENTORY, "rope").?
	testing.expect(t, found)
	testing.expect_value(t, rope.kind, Kind.Tool)

	_, found_sword := find_item(INVENTORY, "sword").?
	testing.expect(t, !found_sword)
}
