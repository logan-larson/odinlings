// quiz2
//
// This quiz covers fixed arrays, structs, enums and unions.
//
// An adventurer carries four item slots. Each slot holds an item of some
// kind, and a number of them.
//
// TODO: Write `count_of_kind`, which adds up how many items of the given
// kind are in the inventory.
//
// TODO: Write `find_item`, which returns the item with the given name, or
// nothing if there is no such item.
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
	return 0
}

find_item :: proc(inventory: Inventory, name: string) -> Maybe(Item) {
	return nil
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
