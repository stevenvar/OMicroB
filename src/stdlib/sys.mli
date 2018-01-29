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

(** System interface.

  Every function in this module raises [Sys_error] with an
  informative message when the underlying system call signal
  an error.
*)

(*external time : unit -> (float [@unboxed]) =
  "caml_sys_time" "caml_sys_time_unboxed" [@@noalloc]*) (*TODO*)
(** Return the processor time, in seconds, used by the program
   since the beginning of execution. *)

val word_size : int
(** Size of one word on the machine currently executing the OCaml
   program, in bits: 32 or 64. *)

val int_size : int
(** Size of an int.  It is 31 bits (resp. 63 bits) when using the
    OCaml compiler on a 32 bits (resp. 64 bits) platform.  It may
    differ for other compilers, e.g. it is 32 bits when compiling to
    JavaScript.
    @since 4.03.0 *)

val big_endian : bool
(** Whether the machine currently executing the Caml program is big-endian.
    @since 4.00.0 *)

val max_string_length : int
(** Maximum length of strings and byte sequences. *)

val max_array_length : int
(** Maximum length of a normal array.  The maximum length of a float
    array is [max_array_length/2] on 32-bit machines and
    [max_array_length] on 64-bit machines. *)

val ocaml_version : string
(** [ocaml_version] is the version of OCaml.
    It is a string of the form ["major.minor[.patchlevel][+additional-info]"],
    where [major], [minor], and [patchlevel] are integers, and
    [additional-info] is an arbitrary string. The [[.patchlevel]] and
    [[+additional-info]] parts may be absent. *)
