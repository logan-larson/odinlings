// error_handling2
package main

import "core:testing"

Signup_Error :: enum {
	None,
	Name_Too_Short,
	Name_Too_Long,
	Too_Young,
}

User :: struct {
	name: string,
	age:  int,
}

validate_name :: proc(name: string) -> Signup_Error {
	if len(name) < 2 {
		return .Name_Too_Short
	}
	if len(name) > 20 {
		return .Name_Too_Long
	}
	return .None
}

validate_age :: proc(age: int) -> Signup_Error {
	if age < 13 {
		return .Too_Young
	}
	return .None
}

// If a validator returns anything but `.None`, `or_return` returns from
// `register` with `user` as it is (empty) and `err` set to that error.
register :: proc(name: string, age: int) -> (user: User, err: Signup_Error) {
	validate_name(name) or_return
	validate_age(age) or_return
	return User{name = name, age = age}, .None
}

main :: proc() {
}

@(test)
test_valid_signup :: proc(t: ^testing.T) {
	user, err := register("Ada", 36)
	testing.expect_value(t, err, Signup_Error.None)
	testing.expect_value(t, user.name, "Ada")
}

@(test)
test_invalid_signups :: proc(t: ^testing.T) {
	_, err := register("A", 36)
	testing.expect_value(t, err, Signup_Error.Name_Too_Short)
	_, err = register("Ada", 9)
	testing.expect_value(t, err, Signup_Error.Too_Young)
	_, err = register("Bartholomew Montgomery", 40)
	testing.expect_value(t, err, Signup_Error.Name_Too_Long)
}
