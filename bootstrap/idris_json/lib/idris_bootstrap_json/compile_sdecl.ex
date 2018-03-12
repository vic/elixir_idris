defmodule IdrisBootstrap.Json.CompileSdecl do
  @moduledoc "Compile Simple Declarations" && false

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

    end
  end

end
