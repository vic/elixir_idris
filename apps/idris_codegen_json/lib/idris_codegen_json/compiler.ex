defmodule Idris.Codegen.JSON.Compiler do
  @moduledoc false && """

  https://github.com/idris-lang/Idris-dev/blob/f92ecd25d48a9120abfbb7d6af81f9b194ab98f1/src/IRTS/Portable.hs
  """

  defmacro __using__(do: code) do
    implemented = __MODULE__.__info__(:functions)
    quote do
      import unquote(__MODULE__.TODO),
        except: unquote(implemented)
      import unquote(__MODULE__)
      unquote(code)
    end
  end

  def cg_Module(module, defs) do
    raise "TODO"
  end

  def cg_Loc({module, fname}, i) do
    {:"var#{i}", [var: i, loc: i, fname: fname], module}
  end

end
