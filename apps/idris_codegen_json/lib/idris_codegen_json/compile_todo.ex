defmodule Idris.Codegen.JSON.Compiler.TODO do
  @moduledoc false &&
    """
    These functions were extracted from Idris source to have proper
    argument names, and serve as placeholders until they are implemented
    properly in Compiler.

    Currently, the Compiler uses the simplified AST, thus most cg_F* and cg_D*
    wont be used, most likely.

    Generated from
    https://github.com/idris-lang/Idris-dev/blob/f92ecd25d48a9120abfbb7d6af81f9b194ab98f1/src/IRTS/Portable.hs
    """

  def cg_FCon(_ctx, _n) do
    raise("TODO")
  end

  def cg_FStr(_ctx, _s) do
    raise("TODO")
  end

  def cg_FUnknown(_ctx) do
    raise("TODO")
  end

  def cg_FIO(_ctx, _fd) do
    raise("TODO")
  end

  def cg_FApp(_ctx, _n, _xs) do
    raise("TODO")
  end

  def cg_ExportData(_ctx, _fd) do
    raise("TODO")
  end

  def cg_ExportFun(_ctx, _n, _dsc, _ret, _args) do
    raise("TODO")
  end

  def cg_LFun(_ctx, _opts, _name, _args, _def) do
    raise("TODO")
  end

  def cg_LConstructor(_ctx, _name, _tag, _ar) do
    raise("TODO")
  end

  def cg_LV(_ctx, _lv) do
    raise("TODO")
  end

  def cg_LApp(_ctx, _tail, _exp, _args) do
    raise("TODO")
  end

  def cg_LLazyApp(_ctx, _name, _exps) do
    raise("TODO")
  end

  def cg_LLazyExp(_ctx, _exp) do
    raise("TODO")
  end

  def cg_LForce(_ctx, _exp) do
    raise("TODO")
  end

  def cg_LLet(_ctx, _name, _a, _b) do
    raise("TODO")
  end

  def cg_LLam(_ctx, _args, _exp) do
    raise("TODO")
  end

  def cg_LProj(_ctx, _exp, _i) do
    raise("TODO")
  end

  def cg_LCon(_ctx, _lv, _i, _n, _exps) do
    raise("TODO")
  end

  def cg_LCase(_ctx, _ct, _exp, _alts) do
    raise("TODO")
  end

  def cg_LConst(_ctx, _c) do
    raise("TODO")
  end

  def cg_LForeign(_ctx, _fd, _ret, _exps) do
    raise("TODO")
  end

  def cg_LOp(_ctx, _prim, _exps) do
    raise("TODO")
  end

  def cg_LNothing(_ctx) do
    raise("TODO")
  end

  def cg_LError(_ctx, _s) do
    raise("TODO")
  end

  def cg_Loc(_ctx, _i) do
    raise("TODO")
  end

  def cg_Glob(_ctx, _n) do
    raise("TODO")
  end

  def cg_LConCase(_ctx, _i, _n, _ns, _exp) do
    raise("TODO")
  end

  def cg_LConstCase(_ctx, _c, _exp) do
    raise("TODO")
  end

  def cg_LDefaultCase(_ctx, _exp) do
    raise("TODO")
  end

  def cg_int(_ctx, _i) do
    raise("TODO")
  end

  def cg_bigint(_ctx, _i) do
    raise("TODO")
  end

  def cg_double(_ctx, _d) do
    raise("TODO")
  end

  def cg_char(_ctx, _c) do
    raise("TODO")
  end

  def cg_string(_ctx, _s) do
    raise("TODO")
  end

  def cg_bits8(_ctx, _b) do
    raise("TODO")
  end

  def cg_bits16(_ctx, _b) do
    raise("TODO")
  end

  def cg_bits32(_ctx, _b) do
    raise("TODO")
  end

  def cg_bits64(_ctx, _b) do
    raise("TODO")
  end

  def cg_atype(_ctx, _at) do
    raise("TODO")
  end

  def cg_strtype(_ctx) do
    raise("TODO")
  end

  def cg_worldtype(_ctx) do
    raise("TODO")
  end

  def cg_theworld(_ctx) do
    raise("TODO")
  end

  def cg_voidtype(_ctx) do
    raise("TODO")
  end

  def cg_forgot(_ctx) do
    raise("TODO")
  end

  def cg_ATInt(_ctx, _it) do
    raise("TODO")
  end

  def cg_ATFloat(_ctx) do
    raise("TODO")
  end

  def cg_LPlus(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LMinus(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LTimes(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LUDiv(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LSDiv(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LURem(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LSRem(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LAnd(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LOr(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LXOr(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LCompl(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LSHL(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LLSHR(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LASHR(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LEq(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LLt(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LLe(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LGt(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LGe(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LSLt(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LSLe(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LSGt(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LSGe(_ctx, _aty) do
    raise("TODO")
  end

  def cg_LZExt(_ctx, _from, _to) do
    raise("TODO")
  end

  def cg_LSExt(_ctx, _from, _to) do
    raise("TODO")
  end

  def cg_LTrunc(_ctx, _from, _to) do
    raise("TODO")
  end

  def cg_LStrConcat(_ctx) do
    raise("TODO")
  end

  def cg_LStrLt(_ctx) do
    raise("TODO")
  end

  def cg_LStrEq(_ctx) do
    raise("TODO")
  end

  def cg_LStrLen(_ctx) do
    raise("TODO")
  end

  def cg_LIntFloat(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LFloatInt(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LIntStr(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LStrInt(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LIntCh(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LChInt(_ctx, _ity) do
    raise("TODO")
  end

  def cg_LFloatStr(_ctx) do
    raise("TODO")
  end

  def cg_LStrFloat(_ctx) do
    raise("TODO")
  end

  def cg_LBitCast(_ctx, _from, _to) do
    raise("TODO")
  end

  def cg_LFExp(_ctx) do
    raise("TODO")
  end

  def cg_LFLog(_ctx) do
    raise("TODO")
  end

  def cg_LFSin(_ctx) do
    raise("TODO")
  end

  def cg_LFCos(_ctx) do
    raise("TODO")
  end

  def cg_LFTan(_ctx) do
    raise("TODO")
  end

  def cg_LFASin(_ctx) do
    raise("TODO")
  end

  def cg_LFACos(_ctx) do
    raise("TODO")
  end

  def cg_LFATan(_ctx) do
    raise("TODO")
  end

  def cg_LFATan2(_ctx) do
    raise("TODO")
  end

  def cg_LFSqrt(_ctx) do
    raise("TODO")
  end

  def cg_LFFloor(_ctx) do
    raise("TODO")
  end

  def cg_LFCeil(_ctx) do
    raise("TODO")
  end

  def cg_LFNegate(_ctx) do
    raise("TODO")
  end

  def cg_LStrHead(_ctx) do
    raise("TODO")
  end

  def cg_LStrTail(_ctx) do
    raise("TODO")
  end

  def cg_LStrCons(_ctx) do
    raise("TODO")
  end

  def cg_LStrIndex(_ctx) do
    raise("TODO")
  end

  def cg_LStrRev(_ctx) do
    raise("TODO")
  end

  def cg_LStrSubstr(_ctx) do
    raise("TODO")
  end

  def cg_LReadStr(_ctx) do
    raise("TODO")
  end

  def cg_LWriteStr(_ctx) do
    raise("TODO")
  end

  def cg_LSystemInfo(_ctx) do
    raise("TODO")
  end

  def cg_LFork(_ctx) do
    raise("TODO")
  end

  def cg_LPar(_ctx) do
    raise("TODO")
  end

  def cg_LExternal(_ctx, _name) do
    raise("TODO")
  end

  def cg_LCrash(_ctx) do
    raise("TODO")
  end

  def cg_LNoOp(_ctx) do
    raise("TODO")
  end

  def cg_DFun(_ctx, _name, _args, _exp) do
    raise("TODO")
  end

  def cg_DConstructor(_ctx, _name, _tag, _arity) do
    raise("TODO")
  end

  def cg_DV(_ctx, _lv) do
    raise("TODO")
  end

  def cg_DApp(_ctx, _tail, _name, _exps) do
    raise("TODO")
  end

  def cg_DLet(_ctx, _name, _a, _b) do
    raise("TODO")
  end

  def cg_DUpdate(_ctx, _name, _exp) do
    raise("TODO")
  end

  def cg_DProj(_ctx, _exp, _i) do
    raise("TODO")
  end

  def cg_DC(_ctx, _lv, _i, _name, _exp) do
    raise("TODO")
  end

  def cg_DCase(_ctx, _ct, _exp, _alts) do
    raise("TODO")
  end

  def cg_DChkCase(_ctx, _exp, _alts) do
    raise("TODO")
  end

  def cg_DConst(_ctx, _c) do
    raise("TODO")
  end

  def cg_DForeign(_ctx, _fd, _ret, _exps) do
    raise("TODO")
  end

  def cg_DOp(_ctx, _prim, _exps) do
    raise("TODO")
  end

  def cg_DNothing(_ctx) do
    raise("TODO")
  end

  def cg_DError(_ctx, _s) do
    raise("TODO")
  end

  def cg_DConCase(_ctx, _i, _n, _ns, _exp) do
    raise("TODO")
  end

  def cg_DConstCase(_ctx, _c, _exp) do
    raise("TODO")
  end

  def cg_DDefaultCase(_ctx, _exp) do
    raise("TODO")
  end

  def cg_SFun(_ctx, _name, _args, _i, _exp) do
    raise("TODO")
  end

  def cg_SV(_ctx, _lv) do
    raise("TODO")
  end

  def cg_SApp(_ctx, _tail, _name, _exps) do
    raise("TODO")
  end

  def cg_SLet(_ctx, _lv, _a, _b) do
    raise("TODO")
  end

  def cg_SUpdate(_ctx, _lv, _exp) do
    raise("TODO")
  end

  def cg_SProj(_ctx, _lv, _i) do
    raise("TODO")
  end

  def cg_SCon(_ctx, _lv, _i, _name, _vars) do
    raise("TODO")
  end

  def cg_SCase(_ctx, _ct, _lv, _alts) do
    raise("TODO")
  end

  def cg_SChkCase(_ctx, _lv, _alts) do
    raise("TODO")
  end

  def cg_SConst(_ctx, _c) do
    raise("TODO")
  end

  def cg_SForeign(_ctx, _fd, _ret, _exps) do
    raise("TODO")
  end

  def cg_SOp(_ctx, _prim, _vars) do
    raise("TODO")
  end

  def cg_SNothing(_ctx) do
    raise("TODO")
  end

  def cg_SError(_ctx, _s) do
    raise("TODO")
  end

  def cg_SConCase(_ctx, _i, _j, _n, _ns, _exp) do
    raise("TODO")
  end

  def cg_SConstCase(_ctx, _c, _exp) do
    raise("TODO")
  end

  def cg_SDefaultCase(_ctx, _exp) do
    raise("TODO")
  end

  def cg_ASSIGN(_ctx, _r1, _r2) do
    raise("TODO")
  end

  def cg_ASSIGNCONST(_ctx, _r, _c) do
    raise("TODO")
  end

  def cg_UPDATE(_ctx, _r1, _r2) do
    raise("TODO")
  end

  def cg_MKCON(_ctx, _con, _mr, _i, _regs) do
    raise("TODO")
  end

  def cg_CASE(_ctx, _b, _r, _alts, _def) do
    raise("TODO")
  end

  def cg_PROJECT(_ctx, _r, _loc, _arity) do
    raise("TODO")
  end

  def cg_PROJECTINTO(_ctx, _r1, _r2, _loc) do
    raise("TODO")
  end

  def cg_CONSTCASE(_ctx, _r, _alts, _def) do
    raise("TODO")
  end

  def cg_CALL(_ctx, _name) do
    raise("TODO")
  end

  def cg_TAILCALL(_ctx, _name) do
    raise("TODO")
  end

  def cg_FOREIGNCALL(_ctx, _r, _fd, _ret, _exps) do
    raise("TODO")
  end

  def cg_SLIDE(_ctx, _i) do
    raise("TODO")
  end

  def cg_RESERVE(_ctx, _i) do
    raise("TODO")
  end

  def cg_ADDTOP(_ctx, _i) do
    raise("TODO")
  end

  def cg_TOPBASE(_ctx, _i) do
    raise("TODO")
  end

  def cg_BASETOP(_ctx, _i) do
    raise("TODO")
  end

  def cg_REBASE(_ctx) do
    raise("TODO")
  end

  def cg_STOREOLD(_ctx) do
    raise("TODO")
  end

  def cg_OP(_ctx, _r, _prim, _args) do
    raise("TODO")
  end

  def cg_NULL(_ctx, _r) do
    raise("TODO")
  end

  def cg_ERROR(_ctx, _s) do
    raise("TODO")
  end

  def cg_RVal(_ctx) do
    raise("TODO")
  end

  def cg_T(_ctx, _i) do
    raise("TODO")
  end

  def cg_L(_ctx, _i) do
    raise("TODO")
  end

  def cg_Tmp(_ctx) do
    raise("TODO")
  end

  def cg_RigCount(_ctx, _r) do
    raise("TODO")
  end

  def cg_Totality(_ctx, _t) do
    raise("TODO")
  end

  def cg_MetaInformation(_ctx, _m) do
    raise("TODO")
  end

  def cg_Function(_ctx, _ty, _tm) do
    raise("TODO")
  end

  def cg_TyDecl(_ctx, _nm, _ty) do
    raise("TODO")
  end

  def cg_CaseOp(_ctx, _info, _ty, _argTy, _cdefs) do
    raise("TODO")
  end

  def cg_P(_ctx, _nt, _name, _term) do
    raise("TODO")
  end

  def cg_V(_ctx, _n) do
    raise("TODO")
  end

  def cg_Bind(_ctx, _n, _b, _tt) do
    raise("TODO")
  end

  def cg_App(_ctx, _s, _t1, _t2) do
    raise("TODO")
  end

  def cg_Constant(_ctx, _c) do
    raise("TODO")
  end

  def cg_Proj(_ctx, _tt, _n) do
    raise("TODO")
  end

  def cg_Erased(_ctx) do
    raise("TODO")
  end

  def cg_Impossible(_ctx) do
    raise("TODO")
  end

  def cg_Inferred(_ctx, _tt) do
    raise("TODO")
  end

  def cg_TType(_ctx, _u) do
    raise("TODO")
  end

  def cg_UType(_ctx, _u) do
    raise("TODO")
  end

  def cg_UVar(_ctx, _src, _n) do
    raise("TODO")
  end

  def cg_UVal(_ctx, _n) do
    raise("TODO")
  end

  def cg_Complete(_ctx) do
    raise("TODO")
  end

  def cg_MaybeHoles(_ctx) do
    raise("TODO")
  end

  def cg_Holes(_ctx, _ns) do
    raise("TODO")
  end

  def cg_Lam(_ctx, _rc, _bty) do
    raise("TODO")
  end

  def cg_Pi(_ctx, _c, _i, _t, _k) do
    raise("TODO")
  end

  def cg_Let(_ctx, _t, _v) do
    raise("TODO")
  end

  def cg_NLet(_ctx, _t, _v) do
    raise("TODO")
  end

  def cg_Hole(_ctx, _t) do
    raise("TODO")
  end

  def cg_GHole(_ctx, _l, _ns, _t) do
    raise("TODO")
  end

  def cg_Guess(_ctx, _t, _v) do
    raise("TODO")
  end

  def cg_PVar(_ctx, _rc, _t) do
    raise("TODO")
  end

  def cg_PVTy(_ctx, _t) do
    raise("TODO")
  end

  def cg_Impl(_ctx, _a, _b, _c) do
    raise("TODO")
  end

  def cg_Bound(_ctx) do
    raise("TODO")
  end

  def cg_Ref(_ctx) do
    raise("TODO")
  end

  def cg_DCon(_ctx, _a, _b, _c) do
    raise("TODO")
  end

  def cg_TCon(_ctx, _a, _b) do
    raise("TODO")
  end

  def cg_Case(_ctx, _ct, _n, _alts) do
    raise("TODO")
  end

  def cg_ProjCase(_ctx, _t, _alts) do
    raise("TODO")
  end

  def cg_STerm(_ctx, _t) do
    raise("TODO")
  end

  def cg_UnmatchedCase(_ctx, _s) do
    raise("TODO")
  end

  def cg_ImpossibleCase(_ctx) do
    raise("TODO")
  end

  def cg_ConCase(_ctx, _n, _c, _ns, _sc) do
    raise("TODO")
  end

  def cg_FnCase(_ctx, _n, _ns, _sc) do
    raise("TODO")
  end

  def cg_ConstCase(_ctx, _c, _sc) do
    raise("TODO")
  end

  def cg_SucCase(_ctx, _n, _sc) do
    raise("TODO")
  end

  def cg_DefaultCase(_ctx, _sc) do
    raise("TODO")
  end

  def cg_CaseInfo(_ctx, _a, _b, _c) do
    raise("TODO")
  end

  def cg_Accessibility(_ctx, _a) do
    raise("TODO")
  end

end
