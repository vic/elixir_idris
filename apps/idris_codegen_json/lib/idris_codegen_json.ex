defmodule :idris_codegen_json do
  @opts ["--codegenonly", "--portable-codegen", "json"]
  @bin_path Path.expand("../bin", __DIR__)

  def run(argv), do: Idris.Codegen.JSON.Main.run(argv)
  def bin_path, do: @bin_path
  def opts(opts), do: @opts ++ opts
end
