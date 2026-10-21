// quiz1
//
// This quiz covers variables, basic types, procedures and control flow.
//
// A fairground ride sells tickets:
//   - Children younger than 6 ride for free.
//   - Children from 6 to 15 pay 4 coins.
//   - Everyone else pays 9 coins.
//   - On Tuesdays (day 2), everybody pays half price, rounded down.
//
// Days are numbered 0 (Sunday) to 6 (Saturday).
//
// TODO: Write `ticket_price(age, day: int) -> int`, which returns what one
// ticket costs.
//
// TODO: Write `price_for_a_week(age: int) -> int`, which returns what someone
// of that age pays for riding once on every day of the week. Use a loop and
// call `ticket_price`.
package main

import "core:testing"

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

@(test)
test_ticket_price :: proc(t: ^testing.T) {
	testing.expect_value(t, ticket_price(3, 0), 0)
	testing.expect_value(t, ticket_price(6, 1), 4)
	testing.expect_value(t, ticket_price(15, 5), 4)
	testing.expect_value(t, ticket_price(16, 3), 9)
	testing.expect_value(t, ticket_price(80, 6), 9)
}

@(test)
test_tuesday :: proc(t: ^testing.T) {
	testing.expect_value(t, ticket_price(2, 2), 0)
	testing.expect_value(t, ticket_price(10, 2), 2)
	testing.expect_value(t, ticket_price(40, 2), 4)
}

@(test)
test_price_for_a_week :: proc(t: ^testing.T) {
	testing.expect_value(t, price_for_a_week(4), 0)
	testing.expect_value(t, price_for_a_week(10), 26)
	testing.expect_value(t, price_for_a_week(30), 58)
}
