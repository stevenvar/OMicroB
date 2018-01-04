type bit_value = High | Low
type pin_mode = Input | Output
type bit_order = LSB_first | MSB_first
type pin = SS | SCK | MOSI
type register = SPCR | SPSR | SPDR
type bit = MSTR | SPE | SPR1 | SPR0 | SPI2x | SPIF | DORD

external digital_write : pin -> bit_value -> unit = "avr_digital_write"
external pin_mode : pin -> pin_mode -> unit = "avr_pin_mode"
external read_bit : register -> bit -> int = "avr_read_bit"
external set_bit : register -> bit -> unit = "avr_set_bit"
external clear_bit : register -> bit -> unit = "avr_clear_bit"
external write_register : register -> int -> unit = "avr_write_register"
external read_register : register -> int = "avr_read_register"

(* Initialise SPI connection *)
let begin_spi () =
  digital_write SS High;
  pin_mode SS Output;
  set_bit SPCR MSTR;
  set_bit SPCR SPE;
  pin_mode SCK Output;
  pin_mode MOSI Output

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
  while (read_bit SPSR SPIF <> 0) do () done;
  read_register SPDR
