# Memory

Odin has no garbage collector. Memory you allocate with `new`, `make`,
`append` and friends stays allocated until you free it with `free` or
`delete`. Every allocation goes through an allocator, by default
`context.allocator`. `context.temp_allocator` is meant for short-lived
memory that is freed all at once with `free_all`. The test runner and
`mem.Tracking_Allocator` can tell you about memory you forgot to free.

## Further information

- [Odin overview: Implicit context system](https://odin-lang.org/docs/overview/#implicit-context-system)
- [Odin overview: Allocators](https://odin-lang.org/docs/overview/#allocators)
- [Odin overview: Tracking allocator](https://odin-lang.org/docs/overview/#tracking-allocator)
- [Running tests: the memory tracker](https://odin-lang.org/docs/testing/#the-memory-tracker)
- [core:mem package](https://pkg.odin-lang.org/core/mem/)
