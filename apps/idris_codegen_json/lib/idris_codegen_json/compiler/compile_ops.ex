defmodule Idris.Codegen.JSON.CompileOps do
  @moduledoc "Compile Simple Operators" && false

  @ops ~W[
    LPlus
    LMinus
    LTimes
    LUDiv
    LSDivATFloat
    LSDiv
    LURem
    LSRem
    LAnd
    LOr
    LXOr
    LCompl
    LSHL
    LASHR
    LLSHR
    LEq
    LLt
    LLe
    LGt
    LGe
    LSLt
    LSLe
    LSGt
    LSGe
    LSExt
    LZExt
    LTrunc

    LIntFloat
    LFloatInt
    LIntStr
    LStrInt
    LFloatStr
    LStrFloat
    LChInt
    LIntCh
    LBitCast

    LFExp
    LFLog
    LFSin
    LFCos
    LFTan
    LFASin
    LFACos
    LFATan
    LFSqrt
    LFFloor
    LFCeil
    LFNegate

    LStrHead
    LStrTail
    LStrCons
    LStrIndex
    LStrRev
    LStrConcat
    LStrLt
    LStrEq
    LStrLen

    LReadStr
    LWriteStr
  ]

  defmacro __using__(_) do
    ops =
      @ops
      |> Enum.map(fn op ->
        quote do
          defp compile_op(%{unquote(op) => _}) do
            {:., [], [@idris_prim, unquote(String.to_atom(op))]}
          end
        end
      end)

    quote location: :keep do
      defp compile_sexp(sOp(op, args)) do
        args = args |> Enum.map(&compile_sexp/1)
        {compile_op(op), [], args}
      end

      unquote_splicing(ops)

      defp compile_op(sLExternal(sname)) do
        {module, name} = sname_to_module_fname(sname)
        {:., [], [module, name]}
      end
    end
  end
end
