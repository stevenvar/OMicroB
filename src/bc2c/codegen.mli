type word = SBYTE of int | UBYTE of int | OPCODE of Opcode.t

val export : OByteLib.Code.t -> word list * Opcode.t list
