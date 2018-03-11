# IdrisBootstrap.Json

This application provides a bootstrap compiler.

Not for direct usage except by `idirs_elixir`

It's intended to be used to compile the
idris_elixir compiler written in Idris itself.

# mix compile.idris_json

Compile Idris -> JSON IR -> BEAM/Elixir

Usage: mix compile.idris_json [IDRIS_OPTIONS]

## IDRIS_OPTIONS

   Those documented in `idris --help`

## SPECIAL OPTIONS

`--idris EXECUTABLE` - Specify the idris compiler to use

`--output OUTPUT` - Specify where to place output
  Valid values are:

"elixir" - will print elixir code to stdout

"elixir:PATH" - will write a file per module in PATH

"beam:PATH" - will compile into beam bytecode in PATH



## CONFIG

You can also configure this compiler in your `mix.exs`

```elixir
   def project() do
     [
      compilers: [:idris_json] ++ Mix.compilers,
      idris_json: [
        "--output", "elixir:" <> "lib",
        "lib/main.idr"
      ]
     ]
   end
````

See the `example` app.


