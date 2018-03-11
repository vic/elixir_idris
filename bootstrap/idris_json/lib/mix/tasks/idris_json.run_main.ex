defmodule Mix.Tasks.IdrisJson.RunMain do
  use Mix.Task

  @shortdoc "Run Idris main function"
  @moduledoc ~S"""
  mix idris_json.run_main ARGS
  """

  def run(_args) do
    apply(IdrisBootstrap.Idris.Kernel, :bl_runMain_0_br, [])
  end
end
