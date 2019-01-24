open Avr

(* Initialise SPI connection *)
let begin_spi ~ss ~sck ~mosi =
  pin_mode ss OUTPUT;
  set_bit SPCR B4;
  set_bit SPCR B6;
  pin_mode sck OUTPUT;
  pin_mode mosi OUTPUT

(* Close SPI connection *)
let end_spi () =
  clear_bit SPCR B6

(* Emit data through the SPI connection *)
let transfer data =
  write_register SPDR data;
  while (read_bit SPSR B7 <> true) do () done
