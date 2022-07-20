(*************************************************************************)
(*                                                                       *)
(*                                OCaPIC                                 *)
(*                                                                       *)
(*                             Benoit Vaugon                             *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../../LICENSE-en.                                      *)
(*                                                                       *)
(*************************************************************************)

open Types

module CGRAM(M : Simul.MCUSimul) = struct
  open DisplayTypes(M)

  let create () = Array.init 8 (fun _ -> Array.make_matrix 8 5 false);;

  let get_current_line display =
    let ascii_ind = (display.ram_addr lsr 3) land 0b111 in
    let line_ind = (display.ram_addr land 0b111) in
    display.cgram.(ascii_ind).(line_ind)
  ;;

  let write n display =
    assert (display.selected_ram = CGRam);
    let line = get_current_line display in
    for i = 0 to 4 do
      line.(i) <- n land (1 lsl (4 - i)) <> 0;
    done;
    display.ram_addr <- (display.ram_addr + 1) land 63;
  ;;

  let read display =
    assert (display.selected_ram = CGRam);
    let line = get_current_line display in
    let rec f i acc =
      if i = 5 then acc
      else if line.(i) then f (i + 1) (acc lor (1 lsl (5 - i)))
      else f (i + 1) acc
    in
    f 0 0
  ;;
end
