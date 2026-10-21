package odinlings

Key :: enum {
	None,
	Char,
	Enter,
	Up,
	Down,
	Escape,
	Ctrl_C,
}

Key_Event :: struct {
	key: Key,
	ch:  rune, // for `.Char`
}
