(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

module type Button = sig
  val init: unit -> unit
  val is_on: unit -> bool
end

(*******************************************************************************)

module type Display = sig
  val init: unit -> unit
  val print_int: int -> unit
  val print_string: string -> unit
  val print_newline: unit -> unit
  val print_image: bool list list -> unit
  val set_pixel: int -> int -> bool -> unit
  val clear_screen: unit -> unit
end

(*******************************************************************************)
