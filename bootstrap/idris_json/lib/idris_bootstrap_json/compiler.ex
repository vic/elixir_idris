defmodule IdrisBootstrap.Json.Compiler do
  use Expat
  import IdrisBootstrap.Json.Patterns

  @idris_ns IdrisBootstrap.Idris
  @idris_core Module.concat(@idris_ns, Core)
  @idris_kernel Module.concat(@idris_ns, Kernel)
  def compile(json = idris_json(), _opts) do
    simple_decls(sdecls) = json
    sdecls |> Enum.each(&compile_sdecl/1)
  end

  defp compile_sdecl(sfun(sname, fsize, _, body)) do
    # TODO: we should have a single process per module
    # if we find a new function for him, that process
    # should be responsible for collecting its functions
    # At the end, we should send all those processes
    # an exit signal so they can compile their code
    # in maybe using elixir's parallel compiler

    {module, fname} = sname_to_module_fname(sname)
    vars = generate_vars(fsize, module)
    {expr, vars, _module} = compile_sexp(body, vars, module)

    vars = underscore_unused(vars, expr)

    code = quote do
      @module unquote(module)
      def unquote(fname)(unquote_splicing(vars)) do
        unquote(expr)
      end
    end

    IO.puts(Macro.to_string(code))

    {vars, code}
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

  defp call({@idris_kernel, fname, args}, vars, module = @idris_kernel) do
    call({@idris_core, fname, args}, vars, module)
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
  defp let_in({var, expr, _in_expr = {a, b, [var | c]}}, vars, module) do
    code = quote do
      unquote(expr) |> unquote({a, b, c})
    end
    {code, vars, module}
  end

  # second arg inlineable
  defp let_in({var, expr, _in_expr = {a, b, [c, var | d]}}, vars, module) do
    code = {a, b, [c, expr | d]}
    {code, vars, module}
  end

  defp let_in({var, expr, in_expr}, vars, module) do
    code = quote do
      unquote(var) = unquote(expr)
      unquote(in_expr)
    end
    {code, vars, module}
  end

  defp generate_vars(names, module) do
    names
    |> Stream.with_index
    |> Enum.map(fn {_, i} -> loc_to_var(i, nil, module) end)
  end

  defp sname_to_module_fname(sname) do
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
