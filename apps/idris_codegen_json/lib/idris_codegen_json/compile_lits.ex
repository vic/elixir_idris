defmodule Idris.Codegen.JSON.CompileLits do
  @moduledoc "Compile Simple Literals" && false

  defmacro __using__(_) do
    quote location: :keep do

      defp compile_sexp(sNothing()), do: nil
      defp compile_sexp(sInt(value)), do: value
      defp compile_sexp(sBigInt(value)), do: Integer.parse(value) |> elem(0)
      defp compile_sexp(sString(value)), do: value
      defp compile_sexp(sLoc(index)), do: var(index)
      defp compile_sexp(sConst(expr)), do: compile_sexp(expr)
      defp compile_sexp(sV(expr)), do: compile_sexp(expr)

      defp compile_sexp(sChar(value)) do
        value
        |> String.replace_leading("\"'", "")
        |> String.replace_trailing("'\"", "")
        |> to_charlist
      end


    end
  end
end
