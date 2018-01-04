open Spi

(* The boot program for the SSD1306 display *)
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
  List.iter SPI.transfer prog

(* Put the display in command mode *)
let command_mode cs dc () =
  let cspinmask = 0x00 in
  let dcpinmask = 0x00 in
  write_register cs (read_register cs lor cspinmask);
  write_register dc (read_register dc land (lnot dcpinmask));
  write_register cs (read_register cs land (lnot cspinmask))

(* Put the display in data mode *)
let data_mode cs dc () =
  let cspinmask = 0x00 in
  let dcpinmask = 0x00 in
  write_register dc (read_register dc lor dcpinmask);
  write_register cs (read_register cs land (lnot cspinmask))

(* Booting sequence *)
let boot_oled () =
  let spi_clock_div2 = 0x04 in
  Spi.set_clock_divider spi_clock_div2;
  command_mode();
  transfer_program boot_program;
  data_mode ()
