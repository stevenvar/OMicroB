type t = A16 | A32 | A64

let of_int n =
  match n with
  | 16 -> A16
  | 32 -> A32
  | 64 -> A64
  | _  -> Tools.fail "invalid architercture: %d (16, 32 or 64 expected)" n

let to_string arch =
  match arch with
  | A16 -> "16"
  | A32 -> "32"
  | A64 -> "64"

let byte_count arch =
  match arch with
  | A16 -> 2
  | A32 -> 4
  | A64 -> 8
