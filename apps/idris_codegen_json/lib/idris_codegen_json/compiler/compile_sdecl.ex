defmodule Idris.Codegen.JSON.CompileSdecl do
  @moduledoc "Compile Simple Declarations" && false

  defmacro __using__(_) do
    quote location: :keep do
      defp compile_sdecl(sFun(sname, args, body)) do
        {module, fname} = sname_to_module_fname(sname)

        args = 0..length(args) |> Enum.map(&var/1)
        body = compile_sexp(body)

        args = underscore_unused_args(args, body)
        body = underscore_unused_in_body(body)

        uname =
          if to_string(fname) =~ ~r/^[a-z]/ do
            fname
          else
            {:unquote, [], [fname]}
          end

        code =
          quote do
            def unquote(uname)(unquote_splicing(args)) do
              unquote(body)
            end
          end

        {{module, fname, length(args)}, code}
      end
    end
  end
end
