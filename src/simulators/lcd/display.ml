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
    port = Simul.SPDR;
    column_nb = column_nb;
    line_nb = line_nb;
    width = column_nb;
    height = 8 * line_nb;
    matrix = Array.make_matrix 128 64 false;
    ddram = Ddram.create ();
    mode = Data
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
  let config = Printf.sprintf " %dx%d" (display.width*2) (display.height*2) in
  open_graph config;
  set_window_title "LCD display";
  (* display_mode false; *)
  (* display_border display; *)
  sync_display ()


let set_pixel x y display =
  let y = 63 - y in (* must invert because of Graphics y positions ... *)
  (* in the physical screen, pixels are white when on *)
  set_color white;
  fill_rect (display.x+x*2) (display.y+y*2) 2 2

let clear_pixel _x _y =
  set_color black; ()
  (* fill_rect (x+4*x) (y+4*(7-y)) 2 2 *)

let show display =
  (* Graphics.clear_graph (); *)
  let matrix = display.matrix in
  let height = display.height in
  let width = display.width in
  set_color black;
  Graphics.fill_rect display.x display.y (width*2) (height*2);
  let disp i j v =
    match v with
    | true -> set_pixel i j display
    | false -> ()
  in
  begin try
    for i = 0 to width - 1 do
      for j = 0 to height - 1 do
        disp i j matrix.(i).(j)
      done
    done;
    with _ -> failwith "show"
  end;
  sync_display ()
