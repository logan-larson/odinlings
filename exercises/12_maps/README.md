# Maps

A map `map[K]V` stores values of type `V` under keys of type `K`. Reading a
missing key gives the zero value; `v, ok := m[k]` and `k in m` tell you
whether the key is there. Maps allocate memory as they grow, so free them with
`delete(m)`. The iteration order of a map is not defined.

## Further information

- [Odin overview: Maps](https://odin-lang.org/docs/overview/#maps)
- [Odin overview: Map container calls](https://odin-lang.org/docs/overview/#map-container-calls)
- [core:slice package (for sorting)](https://pkg.odin-lang.org/core/slice/)
