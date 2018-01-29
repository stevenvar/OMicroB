(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 1996 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

external big_endian : unit -> bool = "%big_endian"
external word_size : unit -> int = "%word_size"
external int_size : unit -> int = "%int_size"
external max_wosize : unit -> int = "%max_wosize"

let big_endian = big_endian ()
let word_size = word_size ()
let int_size = int_size ()
let max_array_length = max_wosize ()
let max_string_length = word_size / 8 * max_array_length - 1

(*external time: unit -> (float [@unboxed]) =
  "caml_sys_time" "caml_sys_time_unboxed" [@@noalloc]*) (* TODO *)

let ocaml_version = "4.06.0"
