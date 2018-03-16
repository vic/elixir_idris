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
    quote do
      defmodule unquote(module) do
        unquote_splicing(defs)
      end
    end
  end

  def cg_SFun({module, fname}, name, args, _nlocals, exp) do
    argv = args |> Stream.with_index |> Enum.map(fn {a, i} ->
      {:"var#{i}", [var: i, arg: a], module}
    end)

    fname = to_string(fname) =~ ~r/^[a-z]/ && fname || {:unquote, [], [fname]}

    quote do
      @doc unquote("Invokes Idris function " <> name)
      def unquote(fname)(unquote_splicing(argv)) do
        unquote(exp)
      end
    end
  end

  def cg_SNothing(_ctx), do: nil
  def cg_SConst(_ctx, c), do: c

  def cg_SV(_ctx, lv), do: lv

  def cg_SCon(_ctx, _lv, _i, "Prelude.Bool.True", _vars = []) do
    true
  end

  def cg_SCon(_ctx, _lv, _i, "Prelude.Bool.False", _vars = []) do
    false
  end

  def cg_SCon(_ctx, _lv, _i, "Prelude.List.Nil", _vars = []) do
    []
  end

  def cg_SCon(_ctx, _lv, _i, "Prelude.List.::", _vars = [a, b]) do
    quote do
      unquote(a) ++ unquote(b)
    end
  end


  def cg_SCon(_ctx, _lv, _i, name, vars) do
    {:{}, [], [String.to_atom(name) | vars]}
  end

  def cg_SCase(_ctx, _ct, lv, alts) do
    {:case, [], [lv, [do: alts]]}
  end

  def cg_SChkCase(_ctx, lv, alts) do
    {:case, [], [lv, [do: alts]]}
  end

  def cg_SConCase(_ctx, _i, _j, n, ns, exp) do
    con = cg_SCon(nil, nil, nil, n, ns)
    {:->, [], [[con], exp]}
  end

  def cg_SConstCase(_ctx, c, exp) do
    {:->, [], [[c], exp]}
  end

  def cg_SDefaultCase(_ctx, exp) do
    {:->, [], [[{:_, [], nil}], exp]}
  end

  def cg_SApp(_ctx, _tail, name, exps) do
    {mod, fun} = mod_fun_name(name)
    {{:., [], [mod, fun]}, [], exps}
  end

  def cg_SOp(_ctx, prim, vars) do
    {prim, [], vars}
  end

  def cg_SLet(_ctx, lv, a, b) do
    quote do
      unquote(lv) = unquote(a)
      unquote(b)
    end
  end

  def cg_ATInt(_ctx, it) do
    {:aty, it}
  end


  def cg_LEq(_ctx, _aty), do: :==
  def cg_LMinus(_ctx, _aty), do: :-

  def cg_LSLt(_ctx, _aty), do: :<
  def cg_LStrEq(_ctx), do: :==
  def cg_LStrCons(_ctx), do: :<>
  def cg_LStrConcat(_ctx), do: :<>
  def cg_LStrHead(_ctx), do: {:., [], [String, :first]}
  def cg_LStrTail(_ctx), do: quote(do: &String.slice(&1, 1))

  def cg_LWriteStr(_ctx), do: {:., [], [Kernel, :puts]}

  def cg_LIntStr(_ctx, _ity), do: :to_string

  def cg_LSExt(_ctx, _from, _to) do
    &(&1 |> to_string |> Integer.parse |> elem(0))
  end

  def cg_LChInt(_ctx, _ity) do
    &(&1 |> to_charlist |> List.first)
  end

  def cg_LExternal(_ctx, name) do
    {mod, fun} = mod_fun_name(name)
    {:., [], [mod, fun]}
  end

  def cg_Loc({module, fname}, i) do
    {:"var#{i}", [var: i, loc: i, fname: fname], module}
  end

  def cg_string(_ctx, s), do: s
  def cg_int(_ctx, i), do: i
  def cg_bigint(_ctx, i), do: i

  def cg_char(_ctx, "'\\" <> <<c>> <>  "'"), do: c - 90
  def cg_char(_ctx, "'" <> <<c>> <>  "'"), do: c
  def cg_char(_ctx, "'\\DEL'"), do: ?\d
  def cg_char(_ctx, "'\\SO'"), do: 0xE
  def cg_char(_ctx, "'\\\\'"), do: ?\\


end
