defmodule IdrisBootstrap.Json.CompileSexp do
  @moduledoc "Compile Simple Expressions" && false

  defmacro __using__(_) do
    quote location: :keep do

      defp compile_sdecl(sfun(sname, fsize, _, body)) do
        {module, fname} = sname_to_module_fname(sname)
        vars = generate_vars(fsize, module)
        {expr, vars, _module} = compile_sexp(body, vars, module)

        vars = underscore_unused(vars, expr)

        uname =
          if to_string(fname) =~ ~r/^[a-z]/ do
            fname
          else
            {:unquote, [], [fname]}
          end

        expr = underscore_unused_in_body(expr)

        code =
          quote do
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

        code =
          quote do
            unquote(@idris_prim).write_string(unquote_splicing(args))
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
        code =
          quote do
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
    end

  end
end
