defmodule Idris.Codegen.JSON.Compiler do

  @idris_ns Idris.Bootstrap
  @idris_kernel Module.concat(@idris_ns, Kernel)
  @idris_prim Module.concat(@idris_ns, Kernel.Prim)

  use Expat
  import Idris.Codegen.JSON.Patterns

  use Idris.Codegen.JSON.{
    CompileSdecl,
    CompileSexp,
    CompileVars,
    CompileLits,
    CompileCase,
    CompileOps
  }

  def compile(json = idris_json(), opts) do
    simple_decls(sdecls) = json

    sdecls
    |> Flow.from_enumerable()
    #|> Flow.reject(&skip?(&1, opts[:skip]))
    #|> Flow.filter(&only?(&1, opts[:only]))
    |> Flow.partition(key: &sdecl_module/1)
    |> Flow.reduce(fn -> %{} end, &sdecl_module_reducer(&1, &2))
    |> Flow.map(&module_ast(&1))
    |> Flow.map(&module_generate(&1, opts[:output], opts))
    |> Flow.run()
  end

  defp skip?(sdecl, mods) do
    sdecl_module(sdecl) in mods
  end

  defp only?(_sdecl, []), do: true

  defp only?(sdecl, mods) do
    sdecl_module(sdecl) in mods
  end

  defp write_elixir_module_in_path({module, code}, path) do
    file = Path.join(path, Macro.underscore(module)) <> ".ex"
    File.mkdir_p!(Path.dirname(file))
    source = ast_to_elixir_source(code)
    File.write!(file, source)
    {module, file}
  end

  defp module_generate({module, code}, "elixir", _opts) do
    IO.puts(ast_to_elixir_source(code))
    {module, nil}
  end

  defp module_generate({module, code}, "elixir:" <> path, _opts) do
    write_elixir_module_in_path({module, code}, path)
  end

  defp module_generate(_, out, _opts) do
    raise "Teach me to compile into #{out}"
  end

  defp ast_to_elixir_source(ast) do
    ast
    |> Macro.to_string()
    |> Code.format_string!()
  rescue
    _ ->
      Macro.to_string(ast)
  end

  defp module_ast({module, defs}) do
    code =
      quote do
        defmodule unquote(module) do
          (unquote_splicing(defs))
        end
      end

    {module, code}
  end

  defp sdecl_module_reducer(sdecl, modules) do
    {{module, _f, _a}, ast} = compile_sdecl(sdecl)
    Map.update(modules, module, [ast], fn xs -> [ast | xs] end)
  end

  defp sdecl_module(sFun(sname, _fsize, _, _body)) do
    {module, _fname} = sname_to_module_fname(sname)
    module
  end

  def idris_kernel, do: @idris_kernel

  def sname_to_module_fname(sname) do
    sname
    |> String.split(~r/.*\./, parts: 2, include_captures: true)
    |> case do
      [name] ->
        {@idris_kernel, String.to_atom(name)}

      ["", mod, ""] ->
           mod = String.replace_trailing(mod, "..", "")
        {Module.concat(@idris_ns, mod), :.}

      ["", mod, name] ->
           mod = String.replace_trailing(mod, ".", "")
        {Module.concat(@idris_ns, mod), String.to_atom(name)}
    end
  end

  import Idris.Codegen.JSON.Patterns, only: []
end
