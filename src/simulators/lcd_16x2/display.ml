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

open Printf;;
open Graphics;;
open Types;;

let green = rgb 0 200 50;;
let blue = rgb 0 50 200;;

module Display(M : Simul.MCUSimul) = struct
  open DisplayTypes(M)
  module Cgram = Cgram.CGRAM(M)
  module Ddram = Ddram.DDRAM(M)

  let create_display x y e rs rw d4 d5 d6 d7 column_nb line_nb =
    let error() = failwith (sprintf "invalid lcd size %dx%d" column_nb line_nb) in
    begin match line_nb with
      | 1 | 2 | 4 -> if column_nb <= 0 || column_nb * line_nb > 80 then error ()
      | _ -> error ()
    end;
    {
      x = x; y = y;
      e = e; rs = rs; rw = rw;
      d4 = d4;
      d5 = d5;
      d6 = d6;
      d7 = d7;
      column_nb = column_nb;
      line_nb = line_nb;
      width = 65 + 23 * column_nb;
      height = 65 + 34 * line_nb;
      matrix = Array.make_matrix 40 2 [|[||]|];
      cgram = Cgram.create ();
      ddram = Ddram.create ();
      selected_ram = DDRam;
      ram_addr = 0;
      line_mode = One;
      cursor_mode = Hide;
      entry_mode_incr = Right;
      shift_display = false;
      display_mode = On;
      font = F5x8;
      bus_mode = Eight;
    }
  ;;

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
      Mutex.unlock sync_mutex;
  ;;

  let display_border display =
    let x = display.x in
    let y = display.y in
    let width = display.width in
    let height = display.height in
    set_color green;
    fill_rect x y width height;
    set_color black;
    fill_rect (x + 10) (y + 10) (width - 20) (height - 20);
    draw_rect (x-1) (y-1) (width+1) (height+1);
    set_color blue;
    fill_rect (x + 20) (y + 20) (width - 40) (height - 40);
  ;;

  let init_graphics display =
    let config = Printf.sprintf " %dx%d" display.width display.height in
    open_graph config;
    set_window_title "LCD display";
    display_mode false;
    display_border display;
    sync_display ();
  ;;

  let display_char x y =
    let disp i j c =
      set_color (if c then white else blue);
      fill_rect (x + 4 * i) (y + 4 * (7 - j)) 2 2;
    in
    Array.iteri (fun j -> Array.iteri (fun i c -> disp i j c));
  ;;

  let show display =
    let matrix = display.matrix in
    let height = display.height in
    let line_nb = display.line_nb in
    let column_nb = display.column_nb in
    let disp i j c =
      display_char (display.x + 36 + 23 * i) (display.y + height - 65 - 34 * j) c
    in
    display_border display;
    begin match line_nb with
      | 1 ->
        for i = 0 to pred column_nb do
          disp i 0 matrix.(i).(0)
        done
      | 2 ->
        for i = 0 to pred column_nb do
          disp i 0 matrix.(i).(0);
          disp i 1 matrix.(i).(1);
        done
      | 4 ->
        for i = 0 to pred column_nb do
          disp i 0 matrix.(i).(0);
          disp i 1 matrix.(i).(1);
          disp i 2 matrix.(i + 20).(0);
          disp i 3 matrix.(i + 20).(1);
        done
      | _ -> ()
    end;
    sync_display ();
  ;;
end
