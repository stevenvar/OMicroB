val clean :
  Arch.t          ->
  OByteLib.Prim.t ->
  OByteLib.Data.t ->
  OByteLib.Code.t ->
  T.ooid * T.value * T.stack * T.globals * OByteLib.Prim.t * OByteLib.Code.t
