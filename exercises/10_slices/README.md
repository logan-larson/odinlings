# Slices

A slice `[]T` is a view into a run of elements that live somewhere else,
such as an array. It stores a pointer and a length. Slicing with `a[low:high]`
makes a view without copying, so writing through a slice changes the
underlying elements. Procedures usually take slices, so they work with any
amount of data.

## Further information

- [Odin overview: Slices](https://odin-lang.org/docs/overview/#slices)
- [Odin overview: Slice literals](https://odin-lang.org/docs/overview/#slice-literals)
- [Odin overview: Nil slices](https://odin-lang.org/docs/overview/#nil-slices)
- [Odin overview: Iterating through slices of structs by value or by reference](https://odin-lang.org/docs/overview/#iterating-through-slices-of-structs-by-value-or-by-reference)
