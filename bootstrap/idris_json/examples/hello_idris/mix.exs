defmodule HelloIdris.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_idris,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      compilers: [:idris_json] ++ Mix.compilers,
      idris_json: [
        "--output", "elixir:_build/#{Mix.env}/lib-idris",
        "lib/main.idr"
      ],
      elixirc_paths: ["lib", "_build/#{Mix.env}/lib-idris"],
      deps: deps()
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
      {:idris_bootstrap_json, path: "../../"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end