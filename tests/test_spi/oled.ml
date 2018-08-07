open Avr

let buffer = Bytes.make 256 '\x00'
    
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
  let row = y lsr 3 in
  let mask = 1 lsl (y land 0b111) in
  let ind = (row lsl 6) lor x in
  let old_c = int_of_char (Bytes.get buffer ind) in
  let new_c = if color then old_c lor mask else old_c land lnot mask in
  Bytes.set buffer ind (char_of_int new_c)

let clear () =
 for _i = 0 to 1023 do
   Spi.transfer 0
 done

let display () =
  for i = 0 to 511 do
    let b = int_of_char (Bytes.get buffer (i land 0xFF)) in
    Spi.transfer b;
    Spi.transfer b;
  done

let write_at ~cs ~dc line column data =
  command_mode cs dc;
  Spi.transfer (0xB0 + line);
  Spi.transfer (column land 0x0F);
  Spi.transfer ((column lsr 4) lor 0x10);
  data_mode cs dc;
  Spi.transfer data
    
let boot ~cs ~dc ~rst =
  digital_write rst HIGH;
  digital_write rst LOW;
  digital_write rst HIGH;
  command_mode cs dc;
  transfer_program boot_program;
  data_mode cs dc;
  clear()
