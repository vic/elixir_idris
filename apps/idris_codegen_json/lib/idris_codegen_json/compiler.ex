defmodule Idris.Codegen.JSON.Compiler do
  @moduledoc false

  import Idris.Codegen.JSON.Main, only: [mod_fun_name: 1]

  defmacro __using__(do: code) do
    implemented = __MODULE__.__info__(:functions)

    quote do
      import unquote(__MODULE__.TODO), except: unquote(implemented)
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

  def cg_SV(_ctx, lv), do: lv

  def cg_SCon(_ctx, lv, _i, name, _vars) do
    raise(inspect(mod_fun_name(name)))
  end

  def cg_SFun(_ctx, name, _args, _i, _exp) do
    raise(inspect(mod_fun_name(name)))
  end
end
