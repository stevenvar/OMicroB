open Spi

module List = struct
  let rec iter f = function
      [] -> ()
    | x::xs -> (f x); iter f xs
end

let boot_program =
  [ 0xD5 ; 0xF0 ; (* Set display clock divisor = 0xF0 *)
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
let command_mode csport dcport =
  let csval = Avr.read_register csport in
  let dcval = Avr.read_register dcport in
  let cspinmask = 0x00 in
  let dcpinmask = 0x00 in
  Avr.write_register csport (csval lor cspinmask);
  Avr.write_register dcport (dcval land (lnot dcpinmask));
  Avr.write_register csport (csval land (lnot cspinmask))

(* Put the display in data mode *)
let data_mode cs dc =
  let cspinmask = 0x00 in
  let dcpinmask = 0x00 in
  Avr.write_register dc (Avr.read_register dc lor dcpinmask);
  Avr.write_register cs (Avr.read_register cs land (lnot cspinmask))

(* Booting sequence *)
let boot () =
  (* let spi_clock_div2 = 0x04 in *)
  (* Spi.set_clock_divider spi_clock_div2; *)
  command_mode PORTD PORTD;
  transfer_program boot_program;
  (* data_mode PORTD PORTD *)
