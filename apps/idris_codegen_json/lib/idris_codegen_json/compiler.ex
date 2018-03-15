defmodule Idris.Codegen.JSON.Compiler do
  @moduledoc false

  defmacro __using__(do: code) do
    quote do
      import Kernel
      import unquote(__MODULE__)
      unquote(code)
    end
  end

  def cg_Module(env, _, _) do
    env.module
  end

  def cg_ATInt(env, _var1), do: env.module
  def cg_LChInt(env, _var1), do: env.module
  def cg_LEq(env, _var1), do: env.module
  def cg_LMinus(env, _var1), do: env.module
  def cg_LSExt(env, _var1, _var2), do: env.module
  def cg_LSLt(env, _var1), do: env.module
  def cg_LExternal(env, _var1), do: env.module
  def cg_LIntStr(env, _var1), do: env.module
  def cg_LStrCons(env), do: env.module
  def cg_LStrConcat(env), do: env.module
  def cg_LStrEq(env), do: env.module
  def cg_LStrHead(env), do: env.module
  def cg_LStrTail(env), do: env.module
  def cg_LWriteStr(env), do: env.module
  def cg_Loc(env, _var1), do: env.module
  def cg_SApp(env, _var1, _var2, _var3), do: env.module
  def cg_SChkCase(env, _var1, _var2), do: env.module
  def cg_SCase(env, _var1, _var2, _var3), do: env.module
  def cg_SCon(env, _var1, _var2, _var3, _var4), do: env.module
  def cg_SConCase(env, _var1, _var2, _var3, _var4, _var5), do: env.module
  def cg_SConst(env, _var1), do: env.module
  def cg_SConstCase(env, _var1, _var2), do: env.module
  def cg_SDefaultCase(env, _var1), do: env.module
  def cg_SFun(env, _var1, _var2, _var3, _var4), do: env.module
  def cg_SLet(env, _var1, _var2, _var3), do: env.module
  def cg_SNothing(env), do: env.module
  def cg_SOp(env, _var1, _var2), do: env.module
  def cg_SV(env, _var1), do: env.module
  def cg_char(env, _var1), do: env.module
  def cg_int(env, _var1), do: env.module
  def cg_bigint(env, _var1), do: env.module
  def cg_string(env, _var1), do: env.module
end
