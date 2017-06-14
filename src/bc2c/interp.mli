type value =
| Int         of int
| Int32       of Int32.t
| Int64       of Int64.t
| Nativeint   of Nativeint.t
| Float       of float
| Float_array of float array
| Bytes       of bytes
| Object      of value array
| Block       of int * value array
| Closure     of closure
| CodePtr     of pc

and closure = {
  ofs  : int;
  ptrs : pc array;
  env  : value array;
}

and pc = int
and stack = value list

val run : OByteLib.Prim.t -> OByteLib.Data.t -> OByteLib.Code.t -> pc * stack
