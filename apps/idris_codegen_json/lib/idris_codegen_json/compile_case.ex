defmodule Idris.Codegen.JSON.CompileCase do
  @moduledoc "Compile Case" && false

  defmacro __using__(_) do
    quote location: :keep do

      defp compile_sexp(sCase(value, clauses)) do
        value = compile_sexp(value)
        clauses = Enum.map(clauses, &compile_case_clause/1)
        {:case, [], [value, [do: clauses]]}
      end


      defp compile_sexp(sChkCaseNoop(loc)) do
        compile_sexp(loc)
      end

      defp compile_case_clause(sDefaultCase(expr)) do
        expr = compile_sexp(expr)
        under = {:_, [], nil}
        clause = {:->, [], [[under], expr]}
      end

      defp compile_case_clause(sConstCase(const, expr)) do
        expr = compile_sexp(expr)
        const = compile_sexp(const)
        clause = {:->, [], [[const], expr]}
      end

      defp compile_case_clause(sConCase(sname, args, expr)) do
        expr = compile_sexp(expr)
        args = Enum.map(args, &compile_sexp/1)
        con = {:{}, [], [sname | args]}
        clause = {:->, [], [[con], expr]}
      end

    end
  end
end
