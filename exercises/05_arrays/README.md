# Fixed arrays

A fixed array `[N]T` holds exactly `N` values of type `T`, and `N` must be
known at compile time. Arrays are values: assigning or passing one copies all
of its elements. Arithmetic works on whole arrays at once, and small arrays
have `x`, `y`, `z` and `w` fields (and swizzles like `.yx`).

## Further information

- [Odin overview: Fixed arrays](https://odin-lang.org/docs/overview/#fixed-arrays)
- [Odin overview: Array programming](https://odin-lang.org/docs/overview/#array-programming)
- [Odin overview: Range-based for loop](https://odin-lang.org/docs/overview/#range-based-for-loop)
