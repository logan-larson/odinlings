# Unions

A union value holds exactly one of several types, and remembers which one.
A type switch (`switch v in u`) runs the case for the type the union holds
right now, and it must handle every variant unless marked `#partial`.
`Maybe(T)` is a union that holds either a `T` or nothing (`nil`).

## Further information

- [Odin overview: Unions](https://odin-lang.org/docs/overview/#unions)
- [Odin overview: Type switch statement](https://odin-lang.org/docs/overview/#type-switch-statement)
- [Odin overview: Maybe(T)](https://odin-lang.org/docs/overview/#maybet)
- [Odin overview: or_else expression](https://odin-lang.org/docs/overview/#or_else-expression)
