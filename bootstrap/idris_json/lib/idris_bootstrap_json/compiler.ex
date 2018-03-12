defmodule IdrisBootstrap.Json.Compiler do
  use Expat
  import IdrisBootstrap.Json.Patterns

  @idris_ns IdrisBootstrap.Idris
  @idris_core Module.concat(@idris_ns, Core)
  @idris_kernel Module.concat(@idris_ns, Kernel)

  def compile(json = idris_json(), opts) do
    simple_decls(sdecls) = json
    sdecls
    |> Flow.from_enumerable()
    |> Flow.reject(&skip?(&1, opts[:skip]))
    |> Flow.filter(&only?(&1, opts[:only]))
    |> Flow.partition(key: &sdecl_module/1)
    |> Flow.reduce(fn -> %{} end, &sdecl_module_reducer(&1, &2))
    |> Flow.map(&module_ast(&1))
    |> Flow.map(&module_generate(&1, opts[:output], opts))
    |> Flow.run
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
    |> Macro.to_string
    |> Code.format_string!
  rescue
    _ ->
      Macro.to_string(ast)
  end

  defp module_ast({module, defs}) do
    code = quote do
      defmodule unquote(module) do
        unquote_splicing(defs)
      end
    end
    {module, code}
  end

  defp sdecl_module_reducer(sdecl, modules) do
    {{module, _f, _a}, ast} = compile_sdecl(sdecl)
    Map.update(modules, module, [ast], fn xs -> [ast | xs] end)
  end

  defp sdecl_module(sfun(sname, _fsize, _, _body)) do
    {module, _fname} = sname_to_module_fname(sname)
    module
  end

  defp compile_sdecl(sfun(sname, fsize, _, body)) do
    {module, fname} = sname_to_module_fname(sname)
    vars = generate_vars(fsize, module)
    {expr, vars, _module} = compile_sexp(body, vars, module)

    vars = underscore_unused(vars, expr)

    uname = if to_string(fname) =~ ~r/^[a-z]/ do
      fname
    else
      {:unquote, [], [fname]}
    end

    expr = underscore_unused_in_body(expr)

    code = quote do
      def unquote(uname)(unquote_splicing(vars)) do
        unquote(expr)
      end
    end

    {{module, fname, length(vars)}, code}
  end

  defp compile_sexp(snothing(), vars, module) do
    {nil, vars, module}
  end

  defp compile_sexp(sconst(string(value)), vars, module) do
    {value, vars, module}
  end

  defp compile_sexp(sv(loc(vindex)), vars, module) do
    var = loc_to_var(vindex, vars, module)
    {var, vars, module}
  end

  defp compile_sexp(sop(lwritestr(), locs), vars, module) do
    args = locs_to_vars(locs, vars, module)
    code = quote do
      unquote(@idris_core).write_string(unquote_splicing(args))
    end
    {code, vars, module}
  end

  defp compile_sexp(sop(lexternal(sname), locs), vars, module) do
    call(sname, locs, vars, module)
  end

  defp compile_sexp(scon(nil, _, sname, locs), vars, module) do
    call(sname, locs, vars, module)
  end

  #
  defp compile_sexp(schk_case_noop(loc), vars, module) do
    var = loc_to_var(loc, vars, module)
    {var, vars, module}
  end

  defp compile_sexp(sapp(_, sname, locs), vars, module) do
    call(sname, locs, vars, module)
  end

  defp compile_sexp(slet(vindex, vexpr, in_expr), vars, module) do
    {vexpr, _, _} = compile_sexp(vexpr, vars, module)
    {in_expr, _, _} = compile_sexp(in_expr, vars, module)
    var = loc_to_var(vindex, vars, module)
    let_in({var, vexpr, in_expr}, vars, module)
  end

  defp call(sname, locs, vars, module) do
    {remote, fname} = sname_to_module_fname(sname)
    args = locs_to_vars(locs, vars, module)
    call({remote, fname, args}, vars, module)
  end

  defp call({remote, fname, args}, vars, module) do
    code = quote do
      unquote(remote).unquote(fname)(unquote_splicing(args))
    end
    {code, vars, module}
  end

  defp locs_to_vars(locs, vars, module) do
    locs |> Enum.map(&loc_to_var(&1, vars, module))
  end

  defp loc_to_var(loc(vindex), vars, module) do
    loc_to_var(vindex, vars, module)
  end

  defp loc_to_var(index, vars, _module) when length(vars) > index do
    Enum.at(vars, index)
  end

  defp loc_to_var(index, _, module) do
    {:"v#{index}", [index: index], module}
  end

  # pipeable
  defp let_in({var, expr = {_, _, _}, _in_expr = {a, b, [var | c]}}, vars, module) do
    code = quote do
      unquote(expr) |> unquote({a, b, c})
    end
    {code, vars, module}
  end

  # calling another function
  defp let_in({var, expr = {_, _, _}, in_expr}, vars, module) do
    code = quote do
      unquote(var) = unquote(expr)
      unquote(in_expr)
    end
    {code, vars, module}
  end

  # literal values
  defp let_in({var, value, _in_expr = {a, b, args}}, vars, module) do
    index = Enum.find_index(args, &(var == &1))
    args = List.update_at(args, index, fn _ -> value end)
    code = {a, b, args}
    {code, vars, module}
  end

  defp generate_vars(names, module) do
    names
    |> Stream.with_index
    |> Enum.map(fn {_, i} -> loc_to_var(i, nil, module) end)
  end

  def idris_kernel, do: @idris_kernel
  def sname_to_module_fname(sname) do
    sname
    |> String.split(".")
    |> case do
         [name] -> {@idris_kernel, String.to_atom(name)}
         names ->
           [name | module] = Enum.reverse(names)
           {Module.concat([@idris_ns] ++ Enum.reverse(module)), String.to_atom(name)}
       end
  end

  defp underscore_unused(vars, expr) do
    used = vars_in_expr(expr)
    vars |> Enum.map(fn var = {a, b, c} ->
      if var in used do
        var
      else
        {:"_#{a}", b, c}
      end
    end)
  end

  defp underscore_unused_in_body(expr) do
    {code, assigned} = vars_assign_in_expr(expr)
    used = vars_in_expr(code)
    expr |> Macro.postwalk(fn
      v = {a, b = [index: _], c} ->
        if v in assigned && v not in used do
          {:"_#{a}", b, c}
        else
          v
        end
      x -> x
    end)
  end

  defp vars_assign_in_expr(expr) do
    noop = fn x, y -> {x, y} end
    Macro.traverse(expr, [], fn
      {:=, _, [var = {a, [index: _], c}, v]}, acc when is_atom(a) and is_atom(c) ->
        {v, [var] ++ acc}
      x, y -> {x, y}
    end, noop)
  end

  defp vars_in_expr(expr) do
    noop = fn x, y -> {x, y} end
    Macro.traverse(expr, [], noop, fn
      var = {a, [index: _], c}, acc when is_atom(a) and is_atom(c) ->
        {var, [var] ++ acc}
      x, y -> {x, y}
    end)
    |> elem(1)
  end

  import IdrisBootstrap.Json.Patterns, only: []
end
