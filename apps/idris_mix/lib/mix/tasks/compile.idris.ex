defmodule Mix.Tasks.Compile.Idris do
  use Mix.Task

  @shortdoc "Compile Idris sources"

  @moduledoc ~S"""
  #{@shortdoc}
  """

  @spec run(OptionParser.argv()) :: :ok | :no_return
  def run(args) do
    :ok = Idris.Mix.Build.compile(args)
  end
end
