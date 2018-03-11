# Idris

**Experimental As Hell**

You just need latest idris installed.

```
cd bootstrap/idris_json
mix deps.get
mix compile

mix compile.idris_json test/examples/hello.idr --output elixir

mix help compile.idris_json
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `idris` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:idris, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/idris](https://hexdocs.pm/idris).

