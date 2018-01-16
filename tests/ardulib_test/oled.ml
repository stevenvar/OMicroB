open Spi
open Avr

type color = OFF | ON

module List = struct
  let rec iter f = function
      [] -> ()
    | x::xs -> (f x); iter f xs
end

external draw_pixel : int -> int -> color -> unit = "caml_avr_draw_pixel"

let boot_program =
  [
    0xD5 ; 0xF0 ; (* Set display clock divisor = 0xF0 *)
    0x8D ; 0x14; (* Enable charge Pump *)
    0xA1 ; (* Set segment re-map *)
    0xC8 ; (* Set COM Output scan direction *)
    0x81; 0xCF; (* Set contrast = 0xCF *)
    0xD9; 0xF1; (* Set precharge = 0xF1 *)
    0xAF; (* Display ON *)
    0x20; 0x00 (* Set display mode = horizontal addressing mode *)
  ]

let transfer_program prog =
  List.iter Spi.transfer prog

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

let blank() =
 for i = 0 to 1023 do
   Spi.transfer(0x88)
 done

(* Booting sequence *)
let boot ~cs ~dc ~rst =
  let spi_clock_div2 = 0x04 in
  (* Spi.set_clock_divider spi_clock_div2; *)
  command_mode cs dc;
  transfer_program boot_program;
  data_mode cs dc;
  blank()
