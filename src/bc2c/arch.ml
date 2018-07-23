type t = A16 | A32 | A64

(******************************************************************************)
    
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

let bit_count arch =
  byte_count arch * 8

let hd_size_bitcnt arch =
  bit_count arch - 8 - 2

(******************************************************************************)
    
let support_int32 arch n =
  match arch with
  | A16 -> -0x4000l <= n && n <= 0x3FFFl
  | A32 -> -0x4000_0000l <= n && n <= 0x3FFF_FFFFl
  | A64 -> true

let support_int64 arch n =
  match arch with
  | A16 -> -0x4000L <= n && n <= 0x3FFFL
  | A32 -> -0x4000_0000L <= n && n <= 0x3FFF_FFFFL
  | A64 -> -0x4000_0000_0000_0000L <= n && n <= 0x3FFF_FFFF_FFFF_FFFFL

let support_nativeint arch n =
  match arch with
  | A16 -> -0x4000n <= n && n <= 0x3FFFn
  | A32 -> -0x4000_0000n <= n && n <= 0x3FFF_FFFFn
  | A64 -> -0x4000_0000_0000_0000n <= n && n <= 0x3FFF_FFFF_FFFF_FFFFn

(******************************************************************************)

let normalize_int arch n =
  match arch with
  | A16 -> (n lsl (63 - 15)) asr (63 - 15)
  | A32 -> (n lsl (63 - 31)) asr (63 - 31)
  | A64 -> n
    
(******************************************************************************)
