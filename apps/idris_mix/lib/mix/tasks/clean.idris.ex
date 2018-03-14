defmodule Mix.Tasks.Clean.Idris do
  use Mix.Task

  @shortdoc "Clean compiled Idris stuff"

  @moduledoc ~S"""
  #{@shortdoc}
  """

  @spec run(OptionParser.argv()) :: :ok | :no_return
  def run(args) do
    :ok = Idris.Mix.Build.clean(args)
  end
end
