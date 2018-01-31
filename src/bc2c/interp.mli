val import_globals :
  OByteLib.Data.t ->
  T.globals

val run :
  Arch.t          ->
  OByteLib.Prim.t ->
  OByteLib.Data.t ->
  OByteLib.Code.t ->
  T.code_ptr * T.ooid * T.value * T.stack * T.globals
