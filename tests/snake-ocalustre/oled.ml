open Avr


external write_buffer : int -> int -> bool -> unit = "caml_buffer_write"
external read_buffer : int -> int -> bool = "caml_buffer_read"
external get_byte_buffer : unit -> int = "caml_buffer_get_byte"


let boot_program =
  [|
    0xD5; 0xF0; (* Set display clock divisor = 0xF0 *)
    0x8D; 0x14; (* Enable charge Pump *)
    0xA1;       (* Set segment re-map *)
    0xC8;       (* Set COM Output scan direction *)
    0x81; 0xCF; (* Set contrast = 0xCF *)
    0xD9; 0xF1; (* Set precharge = 0xF1 *)
    0xAF;       (* Display ON *)
    0x20; 0x00; (* Set display mode = horizontal addressing mode *)
  |]

let transfer_program prog =
  Array.iter Spi.transfer prog

(* Put the display in command mode *)
let command_mode cs dc =
  digital_write cs HIGH;
  digital_write dc LOW;
  digital_write cs LOW

(* Put the display in data mode *)
let data_mode cs dc =
  digital_write dc HIGH;
  digital_write cs LOW

let send_lcd_command cs dc com =
  command_mode cs dc;
  Spi.transfer com;
  data_mode cs dc

let draw x y color =
  write_buffer x y color

let clear() =
 for _i = 0 to 1023 do
   Spi.transfer(0x00)
 done

let display () =
  for _i = 0 to 1023 do
    Spi.transfer(get_byte_buffer())
  done 

let boot ~cs ~dc ~rst =
  digital_write rst HIGH;
  digital_write rst LOW;
  digital_write rst HIGH;
  command_mode cs dc;
  transfer_program boot_program;
  data_mode cs dc;
  clear()
