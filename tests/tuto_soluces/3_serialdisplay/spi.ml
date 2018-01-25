open Avr

(* Initialise SPI connection *)
let begin_spi ~ss ~sck ~mosi =
  pin_mode ss OUTPUT;
  set_bit SPCR MSTR;
  set_bit SPCR SPE;
  clear_bit SPCR SPIE; 
  pin_mode sck OUTPUT;
  pin_mode mosi OUTPUT

(* Close SPI connection *)
let end_spi () =
  clear_bit SPCR SPE

(* Emit data through the SPI connection *)
let transfer data =
  write_register SPDR data;
  pin_mode PIN9 OUTPUT;
  while (read_bit SPSR SPIF) = false do
    ()
  done
