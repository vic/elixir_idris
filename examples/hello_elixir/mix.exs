defmodule HelloElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_elixir,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,

      compilers: [:idris] ++ Mix.compilers,
      deps: deps() ++ idris_deps(),
      elixirc_paths: ["lib", idris_elixir()],
      idris_codegen: {:json,
                      #output: "elixir:" <> idris_elixir(),
                      output: "elixir",
                      ibcsubdir: idris_elixir()},

      # Either specify a main file or an ipkg file.
      idris_main: "lib/Main.idr"
      #idris_ipkg: "hello_elixir.ipkg"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:idris, path: "../../"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp idris_elixir, do: Path.expand("_build/#{Mix.env}/lib-idris")

  defp idris_deps do
    # Same format as regular Mix deps, but these should
    # have the following options set:
    #
    #  idris: :source  - to mark as an Idris source dependency
    #                    its path will be added via `--idrispath` on compilation.
    #
    #  compile: false  - Tell Mix not to compile as it's not exlixir sources.
    #  app: false      - Tell Mix that it's not an OTP application
    #
    [
      # {:quantities, idris: :source, compile: false, app: false, git: "https://github.com/timjb/quantities"}
      # {:hello_idris, idris: :source, compile: false, app: false, path: "../hello_idris"}
    ]
  end
end
