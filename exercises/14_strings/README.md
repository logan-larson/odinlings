# Strings

An Odin `string` is a read-only sequence of bytes in UTF-8, stored as a
pointer and a length. `len(s)` counts bytes, while `for r in s` walks over
the runes (characters). The `core:strings` package has procedures for
trimming, searching, splitting and changing case; the ones that create new
strings take an allocator. A `strings.Builder` builds a string piece by
piece.

## Further information

- [Odin overview: string type](https://odin-lang.org/docs/overview/#string-type)
- [Odin overview: string iteration](https://odin-lang.org/docs/overview/#string-iteration)
- [Odin overview: string type conversions](https://odin-lang.org/docs/overview/#string-type-conversions)
- [core:strings package](https://pkg.odin-lang.org/core/strings/)
- [core:fmt package](https://pkg.odin-lang.org/core/fmt/)
