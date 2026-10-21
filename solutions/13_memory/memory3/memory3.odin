// memory3
package main

import "core:fmt"
import "core:mem"
import "core:testing"

// `tprintf` allocates from `context.temp_allocator`. The memory is released
// by the next `free_all(context.temp_allocator)`, here at the end of the
// test.
player_label :: proc(number: int, name: string) -> string {
	return fmt.tprintf("Player %d: %s", number, name)
}

main :: proc() {
}

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
