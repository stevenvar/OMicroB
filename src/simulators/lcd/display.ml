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

(* open Printf;; *)
open Graphics
open Types

let green = rgb 0 200 50
let blue = rgb 0 50 200

let create_display x y cs dc rst column_nb line_nb =
  {
    x = x;
    y = y;
    cs = cs;
    dc = dc;
    rst = rst;
    column_nb = column_nb;
    line_nb = line_nb;
    width = column_nb;
    height = 8 * line_nb;
    matrix = Array.make_matrix 128 64 false;
    ddram = Ddram.create ();
  }


let sync_display =
  let sync_mutex = Mutex.create () in
  let sync_check = ref false in
  let rec sync_thread () =
    begin try
            Thread.delay 0.1;
            Mutex.lock sync_mutex;
            let must_sync = !sync_check in
            sync_check := false;
            Mutex.unlock sync_mutex;
            if must_sync then synchronize ();
      with exn ->
        Printf.eprintf "Unhandled exception %s\n%!" (Printexc.to_string exn)
    end;
    sync_thread ();
  in
  let _ = Thread.create sync_thread () in
  fun () ->
    Mutex.lock sync_mutex;
    sync_check := true;
    Mutex.unlock sync_mutex


let init_graphics display =
  let config = Printf.sprintf " %dx%d" (display.width*4) (display.height*4) in
  open_graph config;
  set_window_title "LCD display";
  (* display_mode false; *)
  (* display_border display; *)
  sync_display ()


let set_pixel x y =
  let y = 64 - y in (* must invert because of Graphics y positions ... *)
  set_color black;
  fill_rect (x*4) (y*4) 4 4

let clear_pixel _x _y =
  set_color white; ()
  (* fill_rect (x+4*x) (y+4*(7-y)) 2 2 *)

let show display =
  Graphics.clear_graph ();
  let matrix = display.matrix in
  let height = display.height in
  let width = display.width in
  let disp i j v =
    match v with
    | true -> clear_pixel i j (* invert to have the same behaviour as the physical screen *)
    | false -> set_pixel i j
  in
  for i = 0 to width - 1 do
    for j = 0 to height - 1 do
      disp i j matrix.(i).(j)
    done
  done;
  sync_display ()
