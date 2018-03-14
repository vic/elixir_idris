defmodule :idris_codegen_json do
  @opts ["--codegenonly", "--portable-codegen", "json"]
  @bin_path Path.expand("../bin", __DIR__)

  def run(argv), do: Idris.Codegen.JSON.run(argv)
  def bin_path, do: @bin_path
  def opts(opts), do: @opts ++ opts
end

defmodule Idris.Codegen.JSON do
  @moduledoc false

  alias __MODULE__.Compiler

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

  defp skip_and_only_flags(flags) do
    kern = Compiler.idris_kernel()

    modname = &(Compiler.sname_to_module_fname(&1 <> ".fname") |> elem(0))

    only = flags |> Keyword.get_values(:only) |> Enum.map(modname)
    skip = flags |> Keyword.get_values(:skip) |> Enum.map(modname)

    skip =
      cond do
        kern in only -> skip
        :else -> [kern] ++ skip
      end

    flags = flags |> Keyword.delete(:only) |> Keyword.delete(:skip)
    flags = [only: only, skip: skip] ++ flags

    flags
  end

  defp compile_json_files(flags, [json_file]) do
    File.cp!(json_file, "/tmp/idris.json")

    json_file
    |> File.read!()
    |> Jason.decode!()
    |> Compiler.compile([json_file: json_file] ++ flags)
  end
end
