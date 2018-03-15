defmodule Idris.Codegen.JSON.Macrogen do
  @moduledoc """
             Turns turns each node of AST JSON into codegen macros.

             The macros then expand, producing the actual code.
             """ && false

  defp macrogen(m) when map_size(m) == 1 do
    [{name, args}] = Enum.into(m, [])
    args = List.wrap(args)
    {:"cg_#{name}", [], macrogen(args)}
  end

  defp macrogen(args) when is_list(args) do
    Enum.map(args, &compile_form/1)
  end

  defp macrogen(value), do: value

end
