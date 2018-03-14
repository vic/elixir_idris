defmodule Idris.Codegen.JSON.CompileSexp do
  @moduledoc "Compile Simple Expressions" && false

  defmacro __using__(_) do
    quote location: :keep do

      defp compile_sexp(sCon(sname, args)) do
        args = Enum.map(args, &compile_sexp/1)
        {:{}, [], [sname | args]}
      end

      defp compile_sexp(sApp(_, sname, args)) do
        args = Enum.map(args, &compile_sexp/1)
        {module, fname} = sname_to_module_fname(sname)
        quote do
          unquote(module).unquote(fname)(unquote_splicing(args))
        end
      end

      defp compile_sexp(sLet(loc, expr, in_expr)) do
        var = compile_sexp(loc)
        expr = compile_sexp(expr)
        in_expr = compile_sexp(in_expr)
        let_in(var, expr, in_expr)
      end

    end
  end
end
