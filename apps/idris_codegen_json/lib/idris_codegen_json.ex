defmodule :idris_codegen_json do
  @opts ["--codegenonly", "--portable-codegen", "json"]
  @bin_path Path.expand("../bin", __DIR__)

  def run(argv), do: Idris.Codegen.JSON.run(argv)
  def bin_path, do: @bin_path
  def opts(opts), do: @opts ++ opts
end

defmodule Idris.Codegen.JSON do
  @moduledoc false

  @option_parser [
    aliases: [o: :output],
    switches: [
      interface: :boolean,
      output: :string,
      only: :keep,
      skip: :keep
    ]
  ]

  def run(argv) do
    {flags, json_files, _opts} = OptionParser.parse(argv, @option_parser)
    flags = skip_and_only_flags(flags)
    compile_json_files(flags, json_files)
  end

end
