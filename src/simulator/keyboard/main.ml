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

open Graphics;;
open Simul;;

(**************)

let lines   = [| RD6; RD5; RC1; RD0; RC3; RC2; |];;
let columns = [| RA4; RD7; RD4; RA5; RC0; RC7; |];;
let line_nb = Array.length lines;;
let column_nb = Array.length columns;;
let matrix = Array.make_matrix line_nb column_nb false;;

(**************)

let handler _ =
  let rec f li =
    if li < line_nb then
      let rec g co =
        if co = column_nb then
          clear_pin lines.(li)
        else if matrix.(li).(co) && test_pin columns.(co) then
          set_pin lines.(li)
        else
          g (co + 1)
      in
      g 0;
      f (li + 1);
  in
  f 0;
in
Array.iter (fun pin -> add_handler (Change_pin_handler (pin, handler)))
  columns;
;;

(**************)

let sz = 40;;
let mg = 20;;
let width = sz * column_nb + 2 * mg;;
let height = sz * line_nb + 2 * mg;;
let green = rgb 0 200 50;;

open_graph (Printf.sprintf " %dx%d" width height);;
set_color green;;
fill_rect 0 0 width height;;
set_color black;;
fill_rect mg mg (width - 2 * mg) (height - 2 * mg);;
set_color white;;
set_line_width 2;;

for j = 0 to column_nb do
  moveto (sz * j + mg) mg;
  lineto (sz * j + mg) (sz * line_nb + mg);
done;;

for i = 0 to line_nb do
  moveto mg (sz * i + mg);
  lineto (sz * column_nb + mg) (sz * i + mg);
done;;

(**************)

Simul.start ();;
while true do
  let { mouse_x = x ; mouse_y = y ; button = _ ; keypressed = _ ; key = _ } =
    wait_next_event [ Button_down ]
  in
  let li = (y - mg) / sz and co = (x - mg) / sz in
  if li >= 0 && li < line_nb && co >= 0 && co < column_nb then (
    matrix.(li).(co) <- true;
    ignore (wait_next_event [ Button_up ]);
    matrix.(li).(co) <- false;
  );
done;;
Simul.join ();;
