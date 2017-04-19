type word =
| INT     of int
| FLOAT   of float
| CHARS   of char list
| BYTES   of int list
| CUSTOM  of string
| HEADER  of int * int
| POINTER of int

val export : Arch.t -> OByteLib.Data.t -> word list * word list
