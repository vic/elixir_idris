defmodule Mix.Tasks.Idris.Main do
  use Mix.Task

  @shortdoc "Runs Idris main function"
  @moduledoc @shortdoc

  def run(args) do
    IO.inspect(args)
  end
end
