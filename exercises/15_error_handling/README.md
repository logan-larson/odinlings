# Error handling

Odin has no exceptions. A procedure that can fail returns an extra value: a
`bool` that says whether it worked, or an error value, often an enum or a
union whose zero value means "no error". `or_return` passes an error on to
the caller, `or_else` supplies a fallback value, and `or_continue` and
`or_break` skip to the next loop iteration or leave the loop.

## Further information

- [Odin overview: Multiple results](https://odin-lang.org/docs/overview/#multiple-results)
- [Odin overview: or_else expression](https://odin-lang.org/docs/overview/#or_else-expression)
- [Odin overview: or_return operator](https://odin-lang.org/docs/overview/#or_return-operator)
- [Odin overview: or_continue operator](https://odin-lang.org/docs/overview/#or_continue-operator)
- [Odin overview: or_break operator](https://odin-lang.org/docs/overview/#or_break-operator)
