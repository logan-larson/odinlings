// memory3
//
// Every procedure in Odin receives a hidden value called `context`. Among
// other things, it holds two allocators:
//
//     context.allocator        used by new, make, append, ... by default
//     context.temp_allocator   for short-lived memory
//
// Memory from the temp allocator is not freed one piece at a time. Instead,
// everything in it is freed at once with `free_all(context.temp_allocator)`,
// for example once per frame in a game, or once per request in a server.
//
// Many procedures that allocate come in two flavours. `fmt.aprintf` formats
// into memory from `context.allocator`, which the caller must `delete`.
// `fmt.tprintf` uses `context.temp_allocator`, so the result is cleaned up
// by the next `free_all`.
//
// The test below swaps `context.allocator` for a `mem.Tracking_Allocator`,
// which records every allocation that isn't freed.
package main

import "core:fmt"
import "core:mem"
import "core:testing"

// Builds a label like "Player 3: Ada". Callers only use the label right
// away, for printing, so it only needs to live until the next `free_all`.
//
// TODO: This allocates with `context.allocator`, and nobody frees it. Use
// the temp allocator instead.
player_label :: proc(number: int, name: string) -> string {
	return fmt.aprintf("Player %d: %s", number, name)
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_player_label :: proc(t: ^testing.T) {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)
	defer free_all(context.temp_allocator)

	label := player_label(3, "Ada")
	testing.expect_value(t, label, "Player 3: Ada")
	testing.expect_value(t, len(track.allocation_map), 0)
}
