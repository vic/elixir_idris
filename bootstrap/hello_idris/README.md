# HelloIdris

Example hello world app written in Idris.

It uses `idris_json` to compile its sources into `_build/dev/lib-idris`
before the `elixirc` takes them.

See the `mix.exs` file.

```
mix deps.get
mix compile
mix idris_json.run_main
```

