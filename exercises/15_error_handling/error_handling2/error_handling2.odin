// error_handling2
//
// When there is more than one way to fail, return an error value instead of
// a bool. An enum works well, with `None` as its first value, so the zero
// value means "no error":
//
//     Load_Error :: enum {
//         None,
//         File_Not_Found,
//         Bad_Format,
//     }
//
// Passing an error on to your own caller is so common that Odin has an
// operator for it. `or_return` looks at the last result of a call. If it is
// not the zero value, the current procedure returns right away, with that
// error as its own last result:
//
//     load_level :: proc(path: string) -> (level: Level, err: Load_Error) {
//         data := read_file(path) or_return
//         level = parse_level(data) or_return
//         return
//     }
//
// The procedure using `or_return` needs named results, so Odin knows what to
// return for the other results.
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

// TODO: `register` calls the validators, but ignores what they say. Pass
// their errors on to the caller with `or_return`.
register :: proc(name: string, age: int) -> (user: User, err: Signup_Error) {
	validate_name(name)
	validate_age(age)
	return User{name = name, age = age}, .None
}

main :: proc() {
	// You can optionally experiment here.
}

// Don't change the tests!

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
