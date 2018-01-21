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
open Window;;

type led = {
  led_x      : int;
  led_y      : int;
  led_radius : int;
  led_color  : Color.t;
  led_pin    : pin;
  led_inv    : bool;
}

type ledb = {
  ledb_x      : int;
  ledb_y      : int;
  ledb_radius : int;
  ledb_color1 : Color.t;
  ledb_color2 : Color.t;
  ledb_pin1   : pin;
  ledb_pin2   : pin;
  ledb_inv    : bool;
}

type but = {
  but_x       : int;
  but_y       : int;
  but_width   : int;
  but_height  : int;
  but_color   : Color.t;
  but_label   : string;
  but_pin     : pin;
  but_pin_out : pin option;
  but_inv     : bool;
}

type swi = {
  swi_x      : int;
  swi_y      : int;
  swi_width  : int;
  swi_height : int;
  swi_color  : Color.t;
  swi_label  : string;
  swi_pin    : pin;
  swi_def    : bool;
  swi_orient : [ `Horizontal | `Vertical ];
}

type seg7 = {
  seg7_x       : int;
  seg7_y       : int;
  seg7_width   : int;
  seg7_height  : int;
  seg7_disp    : (pin * (int * int) array) array;
  seg7_color   : Color.t;
  seg7_bgcolor : Color.t;
  seg7_point   : pin option;
  seg7_common  : pin option;
  seg7_inv     : bool;
}

type ana = {
  ana_x      : int;
  ana_y      : int;
  ana_width  : int;
  ana_length : int;
  ana_orient : [ `Horizontal | `Vertical ];
  ana_color  : Color.t;
  ana_an     : an;
  ana_init   : float option;
}

type lcd = Types.display;;

type t =
  | Led  of led
  | Ledb of ledb
  | But  of but
  | Swi  of swi
  | Seg7 of seg7
  | Lcd  of lcd
  | Ana  of ana
;;

let analogs = Hashtbl.create 16;;

let register component = match component with
  | Led { led_x = x; led_y = y; led_radius = r; led_color = c;
          led_pin = p ; led_inv = i } ->
    let draw_on () = draw_led x y r c in
    let draw_off () = draw_led x y r Color.white in
    let (draw_on, draw_off) =
      if i then (draw_off, draw_on) else (draw_on, draw_off)
    in
    add_handler (Set_pin_handler (p, draw_on));
    add_handler (Clear_pin_handler (p, draw_off));
    begin try draw_off ();
      with _ -> failwith (sprintf "invalid led (%d,%d) configuration" x y);
    end
  | Ledb { ledb_x = x; ledb_y = y; ledb_radius = r; ledb_color1 = c1;
           ledb_color2 = c2; ledb_pin1 = p1; ledb_pin2 = p2; ledb_inv = i } ->
    let b1 = c1 land 255 in
    let g1 = (c1 lsr 8) land 255 in
    let r1 = (c1 lsr 16) land 255 in
    let b2 = c2 land 255 in
    let g2 = (c2 lsr 8) land 255 in
    let r2 = (c2 lsr 16) land 255 in
    let r12 = min (r1 + r2) 255 in
    let g12 = min (g1 + g2) 255 in
    let b12 = min (b1 + b2) 255 in
    let c12 = Graphics.rgb r12 g12 b12 in
    let draw _ =
      let p1v = test_pin p1 <> i in
      let p2v = test_pin p2 <> i in
      let c =
        if p1v then
          if p2v then c12 else c1
        else
          if p2v then c2 else Color.gray
      in
      draw_led x y r c
    in
    add_handler (Change_pin_handler (p1, draw));
    add_handler (Change_pin_handler (p2, draw));
    begin try draw ();
      with _ ->
        failwith (sprintf "invalid bicolor led (%d,%d) configuration" x y);
    end
  | But { but_x = x; but_y = y; but_width = w; but_height = h;
          but_color = c; but_label = l; but_pin = p; but_pin_out = po;
          but_inv = i } ->
    let state = ref true in
    let down_handler mx my =
      if x-w/2 < mx && mx < x+(w+1)/2-1 &&
        y-h/2-2 < my && my < y+(h-1)/2-2 then (
          draw_but true x y w h c l;
          begin match po with
            | None -> change_pin p (not i);
            | Some pin_out -> change_pin p (test_pin pin_out);
          end;
          state := true;
        );
    and up_handler () =
      if !state then (
        draw_but false x y w h c l;
        change_pin p i;
        state := false;
      )
    in
    begin match po with
      | None -> ()
      | Some pin_out ->
        let action b = if !state then if b then set_pin p else clear_pin p in
        add_handler (Change_pin_handler (pin_out, action))
    end;
    add_button_down_handler down_handler;
    add_button_up_handler up_handler;
    begin try up_handler () with _ ->
      failwith (sprintf "invalid button (%d, %d) configuration" x y);
    end
  | Swi { swi_x = x; swi_y = y; swi_width = w; swi_height = h;
          swi_color = c; swi_label = l; swi_pin = p; swi_def = d;
          swi_orient = o } ->
    let state = ref (not d) in
    let down_handler = match o with
      | `Horizontal ->
        fun mx my ->
          if x-h/2 < mx && mx < x+(h+1)/2-1 &&
            y-w/2-2 < my && my < y+(w-1)/2-2 then (
              state := not !state;
              draw_swi !state x y w h c l o;
              change_pin p !state;
            );
      | `Vertical ->
        fun mx my ->
          if x-w/2 < mx && mx < x+(w+1)/2-1 &&
            y-h/2-2 < my && my < y+(h-1)/2-2 then (
              state := not !state;
              draw_swi !state x y w h c l o;
              change_pin p !state;
            );
    in
    add_button_down_handler down_handler;
    begin try
      down_handler x y;
    with _ ->
      failwith (sprintf "invalid switch (%d, %d) configuration" x y);
    end
  | Seg7 { seg7_x = x; seg7_y = y; seg7_width = w; seg7_height = h;
           seg7_disp = d; seg7_color = c; seg7_bgcolor = bgc; seg7_point = p;
           seg7_inv = i; seg7_common = m } ->
    let handler _ _ = draw_segs x y w h d c p i m in
    begin try
      draw_seg7 x y w h bgc;
      add_handler (Write_handler handler);
      handler () ();
    with _ ->
      failwith (sprintf "invalid 7 segment (%d,%d) configuration" x y);
    end
  | Lcd lcd ->
    (* Display.display_border lcd; *)
    sync_display ();
    Proto.register lcd;
  | Ana ana ->
    let normalize ana p = min (ana.ana_length - ana.ana_width) (max 0 p) in
    let float_of_ofs ofs = float_of_int (normalize ana ofs) /. float_of_int (ana.ana_length - ana.ana_width) in
    let offset ana pos = normalize ana (int_of_float (pos *. float_of_int (ana.ana_length - ana.ana_width) +. 0.5)) in
    let repaint would_send =
      let (anas, pos, _) = Hashtbl.find analogs ana.ana_an in
      if would_send then write_analog ana.ana_an (int_of_float (float_of_int 0x3FF *. !pos +. 0.5));
      List.iter (fun ana ->
        draw_analog ana.ana_x ana.ana_y ana.ana_width
          ana.ana_length ana.ana_orient ana.ana_color (offset ana !pos)
      ) anas;
      sync_display () in
    let pos =
      try
        let (others, pos, has_init) = Hashtbl.find analogs ana.ana_an in
        (match ana.ana_init with
        | None -> ()
        | Some init ->
          if !has_init then failwith ("multiple definition of initial value for analog entry: " ^ string_of_an ana.ana_an);
          pos := init);
        Hashtbl.replace analogs ana.ana_an (ana :: others, pos, has_init);
        pos
      with Not_found ->
        let pos = ref (match ana.ana_init with None -> 0. | Some init -> init) in
        let handler new_val = pos := (float_of_int new_val +. 0.5) /. float_of_int 0x3FF; repaint false in
        add_handler (Write_an_analog_handler (ana.ana_an, handler));
        Hashtbl.add analogs ana.ana_an ([ ana ], pos, ref (ana.ana_init <> None));
        pos in
    let move_orig = ref None in
    let down_handler mx my =
      if analog_contains_cursor ana.ana_x ana.ana_y ana.ana_width
        ana.ana_length ana.ana_orient (offset ana !pos) mx my then move_orig := Some (mx, my, !pos) in
    let up_handler () = move_orig := None in
    let move_handler mx my = 
      let new_pos = match !move_orig, ana.ana_orient with
        | None, _ -> !pos
        | Some (ox, _, op), `Horizontal -> float_of_ofs (mx - ox + offset ana op)
        | Some (_, oy, op), `Vertical -> float_of_ofs (my - oy + offset ana op) in
      if !pos <> new_pos then (
        pos := new_pos;
        repaint true;
      ) in
    add_button_down_handler down_handler;
    add_button_up_handler up_handler;
    add_mouse_move_handler move_handler;
    repaint true;
;;
