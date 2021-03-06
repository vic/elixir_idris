defmodule Idris.Codegen.JSON.Main do
  @moduledoc false

  @option_parser [
    aliases: [o: :output],
    switches: [
      interface: :boolean,
      output: :string,
      compiler: :atom,
      only: :keep,
      skip: :keep
    ]
  ]

  @compiler Idris.Codegen.JSON.Compiler

  def run(argv) do
    {flags, json_files, _opts} = OptionParser.parse(argv, @option_parser)
    # flags = skip_and_only_flags(flags)
    compile_json_files(flags, json_files)
  end

  defp compile_json_files(flags, [json_file]) do
    File.cp!(json_file, "/tmp/idris.json")

    opts = [json_file: json_file]

    json_file
    |> File.read!()
    |> Jason.decode!()
    |> compile_json(opts ++ flags)
  end

  defp compile_json(json, opts) do
    %{"file-type" => "idris-codegen", "version" => 3} = json
    %{"codegen-info" => %{"simple-decls" => sdecls}} = json

    compiler = Keyword.get(opts, :compiler, @compiler)
    new_map = fn -> %{} end

    sdecls
    |> Flow.from_enumerable()
    |> Flow.map(&mod_fun_decl(&1, compiler))
    |> Flow.partition(key: {:elem, 0})
    |> Flow.reduce(new_map, &mod_reducer/2)
    |> Flow.map(&mod_ast(&1, compiler))
    |> Flow.map(&mod_compile/1)
    |> Flow.map(&mod_emit(&1, opts[:output]))
    |> Flow.run()

    :ok
  end

  defp ast_to_string(ast) do
    ast
    |> Macro.to_string()
    |> Code.format_string!()
  rescue
    _ ->
      Macro.to_string(ast)
  end

  defp write_elixir_module_in_path({module, code}, path) do
    file = Path.join(path, Macro.underscore(module)) <> ".ex"
    File.mkdir_p!(Path.dirname(file))
    source = ast_to_string(code)
    File.write!(file, source)
    {module, file}
  end

  defp mod_compile({module, code}) do
    env = %Macro.Env{module: module}
    {code, _binds} = Code.eval_quoted(code, _binds = [], env)
    {module, code}
  end

  defp mod_emit({module, code}, "elixir") do
    IO.puts(ast_to_string(code))
    {module, code}
  end

  defp mod_emit({module, code}, "elixir:" <> path) do
    write_elixir_module_in_path({module, code}, path)
  end

  defp mod_reducer({module, fname, sdecl}, modules) do
    ast = ast({module, fname}, sdecl)
    Map.update(modules, module, [ast], fn xs -> [ast | xs] end)
  end

  defp mod_ast({module, asts}, compiler) do
    code =
      quote do
        use unquote(compiler), do: cg_Module(unquote(module), unquote(asts))
      end

    {module, code}
  end

  defp ast(ctx, map) when map_size(map) == 1 do
    [{name, args}] = Enum.into(map, [])
    args = List.wrap(args)
    {:"cg_#{name}", [], [ctx] ++ ast(ctx, args)}
  end

  defp ast(ctx, args) when is_list(args) do
    Enum.map(args, &ast(ctx, &1))
  end

  defp ast(_ctx, value), do: value

  defp mod_fun_decl([name, decl], compiler) do
    {module, fname} = compiler.mod_fun_name(name)
    {module, fname, decl}
  end
end
