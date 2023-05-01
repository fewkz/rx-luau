# rx-luau

An implementation of [ReactiveX](https://reactivex.io/) in
[Luau](https://luau-lang.org/).

To run the tests, run
`luau --fflags=LuauInterpolatedStringBaseSupport=true test.luau`

## Use in Roblox

You can transpile this library to be usable in Roblox via
[luau-to-rojo](https://github.com/fewkz/luau-to-rojo)

```
luau-to-rojo src roblox --name Rx
```
