defmodule IdrisBootstrap.Json.CompileVars do
  @moduledoc "Compile Var locations" && false

  defmacro __using__(_) do
    quote location: :keep do
      # pipeable
      defp let_in({var, expr = {_, _, _}, _in_expr = {a, b, [var | c]}}, vars, module) do
        code =
          quote do
            unquote(expr) |> unquote({a, b, c})
          end

        {code, vars, module}
      end

      # calling another function
      defp let_in({var, expr = {_, _, _}, in_expr}, vars, module) do
        code =
          quote do
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
        |> Stream.with_index()
        |> Enum.map(fn {_, i} -> loc_to_var(i, nil, module) end)
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

      defp underscore_unused(vars, expr) do
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
