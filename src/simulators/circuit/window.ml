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
open Simul;;

type window = {
  win_width   : int;
  win_height  : int;
  win_bgcolor : Color.t;
  win_title   : string;
}

let window = ref None;;

let text_color c =
  let b = c mod 256 in
  let g = (c / 256) mod 256 in
  let r = (c / 65536) mod 256 in
  if r + g + b < 3 * 128 then Color.white else Color.black
;;

let set_window w =
  match !window with
    | None -> window := Some w
    | Some _ -> failwith "duplicate window configuration"
;;

let init_graphics () =
  match !window with
  | None -> failwith "window not configurate"
  | Some { win_width = w; win_height = h; win_bgcolor = c; win_title = t } ->
    Graphics.open_graph (sprintf " %dx%d" w h);
    Graphics.set_window_title t;
    Graphics.set_color c;
    Graphics.fill_rect 0 0 w h;
    Graphics.set_color Color.black;
    Graphics.draw_rect 0 0 (w - 1) (h - 1);
    Graphics.display_mode false;
    Graphics.auto_synchronize false;
;;

let sync_display =
  let sync_mutex = Mutex.create () in
  let sync_check = ref false in
  let rec sync_thread () =
    begin
      try
        Thread.delay 0.01;
        Mutex.lock sync_mutex;
        let must_sync = !sync_check in
        sync_check := false;
        Mutex.unlock sync_mutex;
        if must_sync then Graphics.synchronize ();
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

let draw_led x y r c =
  Graphics.set_color c;
  Graphics.fill_circle x y r;
  Graphics.set_color Color.black;
  Graphics.draw_circle x y r;
  sync_display ();
;;

let fill_brect x y w h c =
  Graphics.set_color c;
  Graphics.fill_rect x y w h;
  Graphics.set_color Color.black;
  Graphics.draw_rect x y w h;
;;

let draw_but t x y w h c l =
  let x = x - w / 2 in
  let y = y - h / 2 in
  let h = h - 1 in
  let w = w - 1 in
  let (lw, lh) = Graphics.text_size l in
  if c = Color.black then (
    Graphics.set_color Color.black;
    Graphics.fill_rect x y w h;
    Graphics.set_color Color.white;
    if t then Graphics.draw_rect (x+2) (y+1) (w-3) (h-3)
    else Graphics.draw_rect (x+1) (y+2) (w-3) (h-3);
    if t then Graphics.moveto (x + (w - lw + 1) / 2 + 1) (y + (h - lh) / 2)
    else Graphics.moveto (x + (w - lw + 1) / 2) (y + (h - lh) / 2 + 1);
    Graphics.set_color (text_color c);
    Graphics.draw_string l;
  ) else (
    Graphics.set_color Color.black;
    Graphics.fill_rect x y w h;
    Graphics.set_color c;
    if t then Graphics.fill_rect (x+2) (y+1) (w-3) (h-3)
    else Graphics.fill_rect (x+1) (y+2) (w-3) (h-3);
    if t then Graphics.moveto (x + (w - lw + 1) / 2 + 1) (y + (h - lh) / 2)
    else Graphics.moveto (x + (w - lw + 1) / 2) (y + (h - lh) / 2 + 1);
    Graphics.set_color (text_color c);
    Graphics.draw_string l;
  );
  sync_display ();
;;

let draw_swi t x y w h c l o =
  let (wl, hl) = Graphics.text_size l in
  let (w0, h0) = Graphics.text_size "0" in
  let (w1, h1) = Graphics.text_size "1" in
  (match o with
  | `Horizontal ->
    let h = w and w = h in
    let x = x - w / 2 in
    let y = y - h / 2 in
    let bh = h - 4 in
    let bw = w - w0 - w1 - 12 in
    fill_brect x y w h c;
    fill_brect (x + w / 2 - bw / 2) (y + h - bh - 2) bw bh Color.white;
    Graphics.set_color (text_color c);
    Graphics.moveto (x + 5) (y + (h + 1) / 2 - h0 / 2);
    Graphics.draw_string "0";
    Graphics.moveto (x + w - w0 - 2) (y + (h + 1) / 2 - h1 / 2);
    Graphics.draw_string "1";
    if t then
      fill_brect (x+w/2+bw/2-bh+2) (y+h-bh) (bh-4) (bh-4) c
    else
      fill_brect (x+w/2-bw/2+2) (y+h-bh) (bh-4) (bh-4) c;
    Graphics.set_color Color.black;
    Graphics.moveto (x + w / 2 - wl / 2) (y - hl);
    Graphics.draw_string l;
  | `Vertical ->
    let x = x - w / 2 in
    let y = y - h / 2 in
    let bh = h - h0 - h1 - 2 in
    let bw = w - 4 in
    fill_brect x y w h c;
    fill_brect (x + w - bw - 2) (y + h / 2 - bh / 2) bw bh Color.white;
    Graphics.set_color (text_color c);
    Graphics.moveto (x + (w + 1) / 2 - w0 / 2 + 1) (y + 1);
    Graphics.draw_string "0";
    Graphics.moveto (x + (w + 1) / 2 - w1 / 2 + 1) (y + (h + 1) / 2 + bh / 2 + 1);
    Graphics.draw_string "1";
    if t then
      fill_brect (x+w-bw) (y+(h+1)/2+bh/2-bw+2) (bw-4) (bw-4) c
    else
      fill_brect (x+w-bw) (y+h/2-bh/2+2) (bw-4) (bw-4) c;
    Graphics.set_color Color.black;
    Graphics.moveto (x + w / 2 - wl / 2) (y - hl);
    Graphics.draw_string l;
  );
  sync_display ();
;;

let draw_seg7 x y w h bgc =
  Graphics.set_color bgc;
  Graphics.fill_rect (x-w/2) (y-h/2) w h;
  Graphics.set_color Color.black;
  Graphics.draw_rect (x-w/2) (y-h/2) w h;
  sync_display ();
;;

let draw_segs x y w h d c p i m =
  if match m with None -> true | Some m -> test_pin m = i then
      begin
        let draw_seg (pin, poly) =
          Graphics.set_color (if test_pin pin = i then Color.lightgray else c);
          Graphics.fill_poly poly;
          Graphics.set_color Color.gray;
          Graphics.draw_poly poly;
        in
        let draw_point () =
          match p with
            | None -> ()
            | Some p ->
              Graphics.set_color (if test_pin p = i then Color.lightgray else c);
              Graphics.fill_circle (x+w*2/5) (y-h*2/5) (h/20);
              Graphics.set_color Color.gray;
              Graphics.draw_circle (x+w*2/5) (y-h*2/5) (h/20);
        in
        Array.iter draw_seg d;
        draw_point ();
        sync_display ();
      end
;;

let make_seg7_disp x y w h a b c d e f g =
  let x = x - w/16 in
  let h16 = h/16
  and w4 = w/4
  and h25 = h*2/5 in
  let a1 = x - w4 - h16
  and a2 = x - w4 + h16
  and a3 = x + w4 - h16
  and a4 = x + w4 + h16
  and o1 = y - h25 - h16
  and o2 = y - h25 + h16
  and o3 = y - h16
  and o4 = y
  and o5 = y + h16
  and o6 = y + h25 - h16
  and o7 = y + h25 + h16 in
  let p1 = (a1, o1)
  and p2 = (a4, o1)
  and p3 = (a2, o2)
  and p4 = (a3, o2)
  and p5 = (a2, o3)
  and p6 = (a3, o3)
  and p7 = (a1, o4)
  and p8 = (a4, o4)
  and p9 = (a2, o5)
  and p10 = (a3, o5)
  and p11 = (a2, o6)
  and p12 = (a3, o6)
  and p13 = (a1, o7)
  and p14 = (a4, o7) in
  let sa = [| p13 ; p14 ; p12 ; p11 ; p13 |]
  and sb = [| p14 ; p8 ; p10 ; p12 ; p14 |]
  and sc = [| p8 ; p2 ; p4 ; p6 ; p8 |]
  and sd = [| p2 ; p1 ; p3 ; p4 ; p2 |]
  and se = [| p1 ; p7 ; p5 ; p3 ; p1 |]
  and sf = [| p7 ; p13 ; p11 ; p9 ; p7 |]
  and sg = [| p9 ; p10 ; p8 ; p6 ; p5 ; p7 ; p9 |]
  in
  [| (a, sa) ; (b, sb) ; (c, sc) ; (d, sd) ; (e, se) ; (f, sf) ; (g, sg) |]
;;

let analog_contains_cursor x y w l o p mx my = match o with
  | `Horizontal ->
    mx > x - l/2 + 2 + p && mx < x - l/2 + 2 + p + w &&
      my > y - w/2 + 2 && my < y - w/2 + 2 + w
  | `Vertical ->
    mx > x - w/2 + 2 && mx < x - w/2 + 2 + w &&
      my > y - l/2 + 2 + p && my < y - l/2 + 2 + p + w
;;

let draw_analog x y w l o c p = match o with
  | `Horizontal ->
    Graphics.set_color Color.white ; Graphics.fill_rect (x - l/2) (y - w/2) l w;
    Graphics.set_color Color.black ; Graphics.draw_rect (x - l/2) (y - w/2) l w;
    Graphics.set_color Color.black ; Graphics.draw_rect (x - l/2 + 2 + p) (y - w/2 + 2) (w - 4) (w - 4);
    Graphics.set_color c           ; Graphics.fill_rect (x - l/2 + 3 + p) (y - w/2 + 3) (w - 6) (w - 6);
    let prop = 100 * p / (l - w) in
    let xofs = if prop < 10 then 8 else if prop < 100 then 10 else 13 in
    Graphics.set_color Color.black ; Graphics.moveto (x - xofs) (y - w/2 + 6/2); Graphics.draw_string (string_of_int prop ^ " %");
  | `Vertical ->
    Graphics.set_color Color.white ; Graphics.fill_rect (x - w/2) (y - l/2) w l;
    Graphics.set_color Color.black ; Graphics.draw_rect (x - w/2) (y - l/2) w l;
    Graphics.set_color Color.black ; Graphics.draw_rect (x - w/2 + 2) (y - l/2 + 2 + p) (w - 4) (w - 4);
    Graphics.set_color c           ; Graphics.fill_rect (x - w/2 + 3) (y - l/2 + 3 + p) (w - 6) (w - 6);
;;

(***)

let button_down_handlers : (int -> int -> unit) list ref = ref [];;
let button_up_handlers : (unit -> unit) list ref = ref [];;
let mouse_move_handlers : (int -> int -> unit) list ref = ref [];;

let add_button_down_handler handler =
  button_down_handlers := handler :: !button_down_handlers;
;;

let add_button_up_handler handler =
  button_up_handlers := handler :: !button_up_handlers;
;;

let add_mouse_move_handler handler =
  mouse_move_handlers := handler :: !mouse_move_handlers;
;;

let main_loop () =
  let rec loop old_du =
    let status = Graphics.(wait_next_event [ Button_down ; Button_up; Mouse_motion ]) in
    let du = status.Graphics.button in
    let mx = status.Graphics.mouse_x in
    let my = status.Graphics.mouse_y in
    if du <> old_du then
      if du then
        List.iter (fun h -> h mx my) !button_down_handlers
      else
        List.iter (fun h -> h ()) !button_up_handlers
    else
      List.iter (fun h -> h mx my) !mouse_move_handlers;
    loop du in
  loop false
;;
