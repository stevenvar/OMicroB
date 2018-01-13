open Avr

type direction = LSB_first | MSB_first

(* Initialise SPI connection *)
let begin_spi ~ss ~sck ~mosi =
  (* digital_write ss High; *)
  pin_mode ss OUTPUT;
  set_bit SPCR MSTR;
  set_bit SPCR SPE;
  pin_mode sck OUTPUT;
  pin_mode mosi OUTPUT

(* Close SPI connection *)
let end_spi () =
  clear_bit SPCR SPE

(* Mode of transmission *)
let set_bit_order =
  function LSB_first -> set_bit SPCR DORD
         | MSB_first -> clear_bit SPCR DORD

(* Put SPI in data mode *)
let set_data_mode mode =
  let spi_mode_mask = 0x0C in
  let spcr_val = read_register SPCR in
  write_register SPCR ((spcr_val land spi_mode_mask) lor mode)

(* Slow down the serial clock *)
let set_clock_divider rate =
  let spi_clock_mask = 0x30 in
  let spi_clock_mask2x = 0x01 in
  clear_bit SPCR SPR0;
  clear_bit SPCR SPR1;
  write_register SPCR (rate land spi_clock_mask);
  clear_bit SPSR SPI2x;
  write_register SPSR ((rate lsr 2) land spi_clock_mask2x)

(* Emit data through the SPI connection *)
let transfer data =
  write_register SPDR data;
  while (read_bit SPSR SPIF <> false) do () done;
  read_register SPDR
