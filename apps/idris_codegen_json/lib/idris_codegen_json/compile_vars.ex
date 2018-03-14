defmodule Idris.Codegen.JSON.CompileVars do
  @moduledoc "Compile Var locations" && false

  defmacro __using__(_) do
    quote location: :keep do

      defp compile_sexp("{in_" <> var) do
        var
        |> String.replace_trailing("}", "")
        |> fn x -> {String.to_atom(
                       x), [], nil} end.()
      end

      defp compile_sexp("{P_c_" <> var) do
        var
        |> String.replace_trailing("}", "")
        |> fn x -> {String.to_atom(x), [], nil} end.()
      end

      # pipeable last block value
      defp let_in(var, {:__block__, _, block}, _in = {a, b, [var | c]}) do
        [expr | prev] = Enum.reverse(block)
        last = {:|>, [], [expr, {a, b, c}]}
        {:__block__, [], Enum.reverse([last] ++ prev)}
      end

      # pipeable
      defp let_in(var, expr = {_, _, _}, _in = {a, b, [var | c]}) do
        {:|>, [], [expr, {a, b, c}]}
      end

      # var = block
      defp let_in(var, {:__block__, _, block}, in_expr) do
        [last | prev] = Enum.reverse(block)
        last = let_in(var, last, in_expr)
        case last do
          {:__block__, _, bs} ->
            {:__block__, [], Enum.reverse(prev) ++ bs}
          _ ->
            {:__block__, [], Enum.reverse([last] ++ prev)}
        end
      end

      # var in block
      defp let_in(var, expr = {_, _, _}, in_expr = {:__block__, _, block}) do
        quote do
          unquote(var) = unquote(expr)
          unquote_splicing(block)
        end
      end

      # calling function
      defp let_in(var, expr = {_, _, _}, in_expr) do
        quote do
          unquote(var) = unquote(expr)
          unquote(in_expr)
        end
      end

      # literal values
      defp let_in(var, value, _in_expr = {a, b, args}) do
        {_, [index: index], _} = var
        args = List.update_at(args, index, fn _ -> value end)
        {a, b, args}
      end

      defp var(index) when is_integer(index) do
        {:"v#{index}", [index: index], nil}
      end

      defp underscore_unused_args(vars, expr) do
        used = vars_in_expr(expr)

        vars
        |> Enum.map(fn var = {a, b, c} ->
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

        expr
        |> Macro.postwalk(fn
          v = {a, b = [index: _], c} ->
            if v in assigned && v not in used do
              {:"_#{a}", b, c}
            else
              v
            end

          x ->
            x
        end)
      end

      defp vars_assign_in_expr(expr) do
        noop = fn x, y -> {x, y} end

        Macro.traverse(
          expr,
          [],
          fn
            {:=, _, [var = {a, [index: _], c}, v]}, acc when is_atom(a) and is_atom(c) ->
              {v, [var] ++ acc}

            x, y ->
              {x, y}
          end,
          noop
        )
      end

      defp vars_in_expr(expr) do
        noop = fn x, y -> {x, y} end

        Macro.traverse(expr, [], noop, fn
          var = {a, [index: _], c}, acc when is_atom(a) and is_atom(c) ->
            {var, [var] ++ acc}

          x, y ->
            {x, y}
        end)
        |> elem(1)
      end
    end
  end
end
