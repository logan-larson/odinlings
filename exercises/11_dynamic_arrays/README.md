# Dynamic arrays

A dynamic array `[dynamic]T` can grow and shrink while the program runs.
`append` adds elements, `ordered_remove` and `unordered_remove` take them out,
and `pop` removes the last one. A dynamic array allocates memory as it grows,
so it must be freed with `delete` when you are done with it, often right after
creating it with `defer delete(arr)`.

## Further information

- [Odin overview: Dynamic arrays](https://odin-lang.org/docs/overview/#dynamic-arrays)
- [Odin overview: Appending to a dynamic array](https://odin-lang.org/docs/overview/#appending-to-a-dynamic-array)
- [Odin overview: Removing from a dynamic array](https://odin-lang.org/docs/overview/#removing-from-a-dynamic-array)
- [Odin overview: Making and deleting slices and dynamic arrays](https://odin-lang.org/docs/overview/#making-and-deleting-slices-and-dynamic-arrays)
- [Odin overview: Resize / reserve with a dynamic array](https://odin-lang.org/docs/overview/#resize--reserve-with-a-dynamic-array)
