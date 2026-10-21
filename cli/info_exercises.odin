package odinlings

// The course. The order of this table is the order in which exercises are
// presented. Hints are raw strings, so they cannot contain backticks; use
// 'single quotes' around code instead.
when !ODINLINGS_FIXTURE {
	@(rodata)
	EXERCISES := []Exercise_Info {
		// ------------------------------------------------------------ 00_intro
		{
			name = "intro1",
			dir = "00_intro",
			skip_check_unsolved = true,
			hint = `
There is nothing to fix here. Press 'n' to move on to the next exercise.`,
		},
		{
			name = "intro2",
			dir = "00_intro",
			expected_output = `Hellope, Odinlings!`,
			hint = `
The compiler says that 'fmt' is undeclared. Procedures from Odin's core
library live in packages, and a package has to be imported at the top of the
file before you can use it:

    import "core:fmt"`,
		},
		// ------------------------------------------------------------ 01_variables
		{
			name = "variables1",
			dir = "01_variables",
			expected_output = `x has the value 5`,
			hint = `
The compiler says 'x' is undeclared: '=' only assigns to a variable that
already exists. Declare the variable with ':=' instead.`,
		},
		{
			name = "variables2",
			dir = "01_variables",
			expected_output = `score starts at 0
score is now 10`,
			hint = `
'score: int' already declared the variable. The second line tries to declare
it again with ':='. Use '=' to assign the new value.`,
		},
		{
			name = "variables3",
			dir = "01_variables",
			expected_output = `3 weeks have 21 days`,
			hint = `
DAYS_PER_WEEK is a constant ('::'), so it can't be changed. A week has 7 days
anyway, so the assignment can simply go.

'leftover' is declared but never used, which odinlings treats as an error.
Remove it too.`,
		},
		// ------------------------------------------------------------ 02_basic_types
		{
			name = "basic_types1",
			dir = "02_basic_types",
			expected_output = `Total: 30000000120`,
			hint = `
'apples' is an i32 and 'grains_of_rice' is an i64. Convert one so both sides
have the same type: 'i64(apples)'. Which direction is safe? An i64 can hold
every i32 value, but not the other way around.`,
		},
		{
			name = "basic_types2",
			dir = "02_basic_types",
			mode = .Test,
			hint = `
'(a + b) / 2' is an int, and Odin won't turn an int into an f64 by itself.
Convert the sum to f64 before dividing: 'f64(a + b) / 2'.

Converting after dividing, 'f64((a + b) / 2)', compiles, but the integer
division has already thrown the fraction away.`,
		},
		{
			name = "basic_types3",
			dir = "02_basic_types",
			expected_output = `O is for Odin
Is it fun? true
Odin has 4 letters`,
			hint = `
A rune is written in single quotes ('O'); double quotes make a string.
A bool is 'true' or 'false'; numbers are not booleans in Odin.`,
		},
		// ------------------------------------------------------------ 03_procedures
		{
			name = "procedures1",
			dir = "03_procedures",
			expected_output = `2 + 3 = 5`,
			hint = `
Add the return type after the parameter list: 'proc(a, b: int) -> int'.`,
		},
		{
			name = "procedures2",
			dir = "03_procedures",
			mode = .Test,
			hint = `
The tests expect two results. Change the result type to '(int, int)' and
return both values: 'return a / b, a % b'.

Or name the results, '-> (quotient, remainder: int)', set them, and use a bare
'return'.`,
		},
		{
			name = "procedures3",
			dir = "03_procedures",
			mode = .Test,
			hint = `
A default value is written in the parameter list: 'multiplier := 1'.`,
		},
		{
			name = "procedures4",
			dir = "03_procedures",
			mode = .Test,
			hint = `
The compiler can't find a procedure in the 'area' group that takes two
arguments. Add 'area_of_rectangle' to the list inside 'proc { }'.`,
		},
		// ------------------------------------------------------------ 04_control_flow
		{
			name = "control_flow1",
			dir = "04_control_flow",
			mode = .Test,
			hint = `
Add a branch for zero, for example 'else if n == 0 { return "zero" }' after
the negative case.`,
		},
		{
			name = "control_flow2",
			dir = "04_control_flow",
			mode = .Test,
			hint = `
'1 ..< n' stops before n. Use '1 ..= n' to include it.

For 'halvings', declare a local copy, 'x := n', and use 'x' in the loop.`,
		},
		{
			name = "control_flow3",
			dir = "04_control_flow",
			mode = .Test,
			hint = `
The test with a score of exactly 100 fails. '90 ..< 100' excludes 100; '..='
includes the end of the range.`,
		},
		{
			name = "control_flow4",
			dir = "04_control_flow",
			expected_output = `Found 3 * 8 = 24
Tries: 26`,
			hint = `
A plain 'break' only leaves the inner loop, so the outer loop carries on and
finds more pairs. The outer loop is labeled 'search'; write 'break search'.`,
		},
		{
			name = "control_flow5",
			dir = "04_control_flow",
			expected_output = `Opening the bakery
Serving customers
  Baking bread
  Selling bread
  Cleaning the oven
Counting the money
Closing the bakery`,
			hint = `
Put 'defer' in front of both lines that should happen later:

    defer fmt.println("Closing the bakery")

A defer inside the inner block runs at that block's closing brace, while the
one in 'main' runs when 'main' ends.`,
		},
		// ------------------------------------------------------------ quiz1
		{
			name = "quiz1",
			dir = "quizzes",
			mode = .Test,
			hint = `
Start with 'ticket_price :: proc(age, day: int) -> int'. Work out the normal
price with an if/else-if chain, then halve it when day == 2. Integer division
rounds down for you.

'price_for_a_week' can loop with 'for day in 0 ..< 7' and add up
'ticket_price(age, day)'.`,
		},
		// ------------------------------------------------------------ 05_arrays
		{
			name = "arrays1",
			dir = "05_arrays",
			expected_output = `There are 5 planets in the list
The first one is Mercury
The last one is Jupiter`,
			hint = `
The array has 5 elements, numbered 0 to 4, so index 5 is one past the end.
Use 'planets[4]', or better, 'planets[len(planets) - 1]', which keeps working
when the list grows.`,
		},
		{
			name = "arrays2",
			dir = "05_arrays",
			mode = .Test,
			hint = `
'a + b / 2' divides only 'b'. Write '(a + b) / 2'.

To swap the fields, return the swizzle 'v.yx'.`,
		},
		{
			name = "arrays3",
			dir = "05_arrays",
			mode = .Test,
			hint = `
'scores' is a parameter, so it can't be changed. Copy it into a local
variable first, 'result := scores', double the elements of 'result' and
return it.`,
		},
		// ------------------------------------------------------------ 06_structs
		{
			name = "structs1",
			dir = "06_structs",
			expected_output = `Home is at 2 5
The shop is at 7 0
Walking distance: 10`,
			hint = `
Add a 'y: int,' line to the struct, next to 'x'. Fields that a literal leaves
out, like the shop's 'y', get their zero value.`,
		},
		{
			name = "structs2",
			dir = "06_structs",
			mode = .Test,
			hint = `
'area' should return 'room.size.width * room.size.height'.

For 'total_area', loop over the rooms, 'for room in house.rooms', and add up
'area(room)'.`,
		},
		{
			name = "structs3",
			dir = "06_structs",
			mode = .Test,
			hint = `
Write 'using' in front of the field: 'using position: Vec2,'. Then 'e.x'
means 'e.position.x'.`,
		},
		// ------------------------------------------------------------ 07_enums
		{
			name = "enums1",
			dir = "07_enums",
			mode = .Test,
			hint = `
The compiler reports an unhandled switch case. Add 'case .West:' and return
'.North' from it.`,
		},
		{
			name = "enums2",
			dir = "07_enums",
			mode = .Test,
			hint = `
'(int(d) + 2) % len(Direction)' wraps around after the last direction. Convert
the result back with 'Direction(...)'.

For the count, loop with 'for d in Direction' and compare 'int(opposite(d))'
with 'int(d)'.`,
		},
		{
			name = "enums3",
			dir = "07_enums",
			mode = .Test,
			hint = `
An enumerated array is indexed with the enum, not a number: 'deltas[d]'.

Write '#partial switch d' to allow the switch to skip East and West.`,
		},
		// ------------------------------------------------------------ 08_unions
		{
			name = "unions1",
			dir = "08_unions",
			mode = .Test,
			hint = `
Add 'case Triangle:' to the switch and return 's.base * s.height / 2'.`,
		},
		{
			name = "unions2",
			dir = "08_unions",
			mode = .Test,
			hint = `
'nil' is the value of a Maybe that holds nothing. Replace 'return -1' with
'return nil'.`,
		},
		{
			name = "unions3",
			dir = "08_unions",
			mode = .Test,
			hint = `
Ask the assertion for a second result so it can't crash:

    if press, ok := event.(Key_Press); ok {
        return press.key
    }
    return 0`,
		},
		// ------------------------------------------------------------ quiz2
		{
			name = "quiz2",
			dir = "quizzes",
			mode = .Test,
			hint = `
Both procedures loop over the inventory with 'for item in inventory'.

'count_of_kind' adds 'item.count' when 'item.kind == kind'.

'find_item' returns 'item' as soon as 'item.name == name'; returning the item
wraps it in the Maybe. After the loop, return nil.`,
		},
	}
}
