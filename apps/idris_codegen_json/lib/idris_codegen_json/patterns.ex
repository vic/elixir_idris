defmodule Idris.Codegen.JSON.Patterns do
  use Expat

  defpat idris_json(%{
           "file-type" => "idris-codegen",
           "version" => 3
         })

  defpat simple_decls(%{
           "codegen-info" => %{
             "simple-decls" => decls
           }
         })

  defpat sNothing(%{"SNothing" => nil})

  defpat sInt(%{"int" => value})
  defpat sBigInt(%{"bigint" => value})
  defpat sChar(%{"char" => value})
  defpat sString(%{"string" => string})
  defpat sConst(%{"SConst" => const})

  defpat sV(%{"SV" => value})
  defpat sLoc(%{"Loc" => index})

  defpat sApp(%{"SApp" => [flag, name, args]})
  defpat sFun([name, %{"SFun" => [name, args, _, body]}])

  defpat sLet(%{"SLet" => [loc, value, expr]})

  defpat sLEq(%{"LEq" => x})
  defpat sLStrEq(%{"LStrEq" => nil})
  defpat sLStrHead(%{"LStrHead" => nil})
  defpat sLStrTail(%{"LStrTail" => nil})
  defpat sLStrConcat(%{"LStrConcat" => nil})
  defpat sLWriteStr(%{"LWriteStr" => nil})
  defpat sLExternal(%{"LExternal" => name})

  defpat sOp(%{"SOp" => [op, args]})
  defpat sCon(%{"SCon" => [_, _, name, args]})

  defpat sCase(%{"SCase" => ["Shared", loc, cases]})
  defpat sConCase(%{"SConCase" => [_, _, cons, args, expr]})

  defpat sConstCase(%{"SConstCase" => [cons, expr]})

  defpat sChkCase(%{"SChkCase" => [loc, cases]})
  defpat sDefaultCase(%{"SDefaultCase" => value})

  defpat sChkCaseNoop(sChkCase(loc, [sDefaultCase(sV(loc))]))


end
