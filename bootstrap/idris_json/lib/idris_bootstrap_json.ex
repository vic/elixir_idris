defmodule IdrisBootstrap.Json do
  @moduledoc false

  alias __MODULE__.Compiler

  @option_parser [
    aliases: [o: :output],
    switches: [
      interface: :boolean,
      output: :string
    ]
  ]

  def main(argv) do
    {flags, json_files, _opts} = OptionParser.parse(argv, @option_parser)
    compile_json_files(flags, json_files)
  end

  defp compile_json_files(flags, [json_file]) do
    File.cp!(json_file, "/tmp/idris.json")

    json_file
    |> File.read!()
    |> Jason.decode!()
    |> Compiler.compile([json_file: json_file] ++ flags)
  end
end
