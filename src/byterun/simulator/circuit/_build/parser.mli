type token =
  | Name of (string)
  | String of (string)
  | Equal
  | Newline
  | Eof

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Component.t list
