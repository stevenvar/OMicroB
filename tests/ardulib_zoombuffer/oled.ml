open Spi
open Avr


external write_buffer : int -> int -> bool -> unit = "caml_buffer_write"
external read_buffer : int -> int -> bool = "caml_buffer_read"
external get_byte_buffer : int -> int = "caml_buffer_get_byte"
(* external init_buffer : unit -> unit = "caml_init_buffer" *)

let boot_program =
  [|
    0xD5 ; 0xF0 ; (* Set display clock divisor = 0xF0 *)
    0x8D ; 0x14; (* Enable charge Pump *)
    0xA1 ; (* Set segment re-map *)
    0xC8 ; (* Set COM Output scan direction *)
    0x81; 0xCF; (* Set contrast = 0xCF *)
    0xD9; 0xF1; (* Set precharge = 0xF1 *)
    0xAF; (* Display ON *)
    0x20; 0x00 (* Set display mode = horizontal addressing mode *)
  |]

let transfer_program prog =
  Array.iter Spi.transfer prog

(* Put the display in command mode *)
let command_mode cs dc =
  digital_write cs true;
  digital_write dc false;
  digital_write cs false

(* Put the display in data mode *)
let data_mode cs dc =
  digital_write dc true;
  digital_write cs false

let send_lcd_command cs dc com =
  command_mode cs dc;
  Spi.transfer com;
  data_mode cs dc

let display () =
  for i = 0 to 1023 do
    let b = get_byte_buffer i in
    Spi.transfer(b);
  done

let draw x y color =
  write_buffer x y color

let clear() =
 for i = 0 to 1023 do
   Spi.transfer(0x00)
 done

(* let clear_zone ~cs ~dc x y =
 *   let page = y / 8 in
 *   let shift = y mod 8 in
 *   command_mode cs dc;
 *   Spi.transfer (0x21); (\* column *\)
 *   Spi.transfer (x);
 *   Spi.transfer (x);
 *   Spi.transfer (0x22); (\* page *\)
 *   Spi.transfer (page);
 *   Spi.transfer (page);
 *   data_mode cs dc;
 *   Spi.transfer (0x00)
 *
 * let draw ~cs ~dc x y =
 *   let page = y / 8 in
 *   let shift = y mod 8 in
 *   command_mode cs dc;
 *   Spi.transfer (0x21); (\* column *\)
 *   Spi.transfer (x);
 *   Spi.transfer (x);
 *   Spi.transfer (0x22); (\* page *\)
 *   Spi.transfer (page);
 *   Spi.transfer (page);
 *   data_mode cs dc;
 *   Spi.transfer(0x01 lsl shift) *)

(* Booting sequence *)
let boot ~cs ~dc ~rst =
   let spi_clock_div2 = 0x04 in
  (* Spi.set_clock_divider spi_clock_div2; *)
  command_mode cs dc;
  transfer_program boot_program;
  data_mode cs dc;
  (* init_buffer(); *)
  clear();
  (* moveto cs dc 10 10; *)
