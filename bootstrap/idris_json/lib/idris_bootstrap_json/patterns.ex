defmodule IdrisBootstrap.Json.Patterns do
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

  defpat sfun([name, %{"SFun" => [name, args, n, body]}])
  defpat snothing(%{"SNothing" => nil})

  defpat string(%{"string" => string})
  defpat sconst(%{"SConst" => const})

  defpat loc(%{"Loc" => index})
  defpat slet(%{
           "SLet" => [
             loc(index),
             value,
             expr
           ]
         })

  defpat lwritestr(%{"LWriteStr" => nil})
  defpat lexternal(%{"LExternal" => name})
  defpat sop(%{"SOp" => [op, args]})
  defpat scon(%{"SCon" => [lvar, at_tail, name, vars]})
  defpat schk_case(%{"SChkCase" => [loc, cases]})
  defpat sdefault_case(%{"SDefaultCase" => value})

  defpat schk_case_noop(schk_case(loc, [sdefault_case(sv(loc))]))

  defpat sapp(%{"SApp" => [flag, name, args]})
  defpat sv(%{"SV" => loc})
end
