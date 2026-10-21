// quiz1
package main

import "core:testing"

ticket_price :: proc(age, day: int) -> int {
	price: int
	if age < 6 {
		price = 0
	} else if age <= 15 {
		price = 4
	} else {
		price = 9
	}

	// Integer division rounds down, which is what we want here.
	if day == 2 {
		price /= 2
	}
	return price
}

price_for_a_week :: proc(age: int) -> int {
	total := 0
	for day in 0 ..< 7 {
		total += ticket_price(age, day)
	}
	return total
}

main :: proc() {
}

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
