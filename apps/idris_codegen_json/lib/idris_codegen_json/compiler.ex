defmodule Idris.Codegen.JSON.Compiler do
  @moduledoc false

  defmacro __using__(do: code) do
    quote do
      import unquote(__MODULE__)
      unquote(code)
    end
  end

  def cg_Module(env, _, _) do
    raise "TODO"
  end

  def cg_ATInt(env, _var1), do: raise "TODO"
  def cg_LChInt(env, _var1), do: raise "TODO"
  def cg_LEq(env, _var1), do: raise "TODO"
  def cg_LMinus(env, _var1), do: raise "TODO"
  def cg_LSExt(env, _var1, _var2), do: raise "TODO"
  def cg_LSLt(env, _var1), do: raise "TODO"
  def cg_LExternal(env, _var1), do: raise "TODO"
  def cg_LIntStr(env, _var1), do: raise "TODO"
  def cg_LStrCons(env), do: raise "TODO"
  def cg_LStrConcat(env), do: raise "TODO"
  def cg_LStrEq(env), do: raise "TODO"
  def cg_LStrHead(env), do: raise "TODO"
  def cg_LStrTail(env), do: raise "TODO"
  def cg_LWriteStr(env), do: raise "TODO"
  def cg_Loc(env, _var1), do: raise "TODO"
  def cg_SApp(env, _var1, _var2, _var3), do: raise "TODO"
  def cg_SChkCase(env, _var1, _var2), do: raise "TODO"
  def cg_SCase(env, _var1, _var2, _var3), do: raise "TODO"
  def cg_SCon(env, _var1, _var2, _var3, _var4), do: raise "TODO"
  def cg_SConCase(env, _var1, _var2, _var3, _var4, _var5), do: raise "TODO"
  def cg_SConst(env, _var1), do: raise "TODO"
  def cg_SConstCase(env, _var1, _var2), do: raise "TODO"
  def cg_SDefaultCase(env, _var1), do: raise "TODO"
  def cg_SFun(env, _var1, _var2, _var3, _var4), do: raise "TODO"
  def cg_SLet(env, _var1, _var2, _var3), do: raise "TODO"
  def cg_SNothing(env), do: raise "TODO"
  def cg_SOp(env, _var1, _var2), do: raise "TODO"
  def cg_SV(env, _var1), do: raise "TODO"
  def cg_char(env, _var1), do: raise "TODO"
  def cg_int(env, _var1), do: raise "TODO"
  def cg_bigint(env, _var1), do: raise "TODO"
  def cg_string(env, _var1), do: raise "TODO"
end
