open Avr

(* Initialise SPI connection *)
let begin_spi ~ss ~sck ~mosi =
  pin_mode ss OUTPUT;
  set_bit SPCR BIT4;
  set_bit SPCR BIT6;
  pin_mode sck OUTPUT;
  pin_mode mosi OUTPUT
  (* mettre ss en sortie *)
  (* passer l'arduboy en mode maître *)
  (* activer le SPI *)
  (* mettre sck et mosi en sortie *)

(* Close SPI connection *)
  let end_spi () =
    clear_bit SPCR BIT6
(* desactiver le SPI *)

(* Emit data through the SPI connection *)
let transfer data =
  write_register SPDR data;
  while (not (read_bit SPSR BIT7)) do () done
  (* écrire dans le registre SPDR *)
  (* attendre que SPSR[SPIF] vaille 1 *)

