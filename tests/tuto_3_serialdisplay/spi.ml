open Avr

(* Initialise SPI connection *)
let begin_spi ~ss ~sck ~mosi =
  ()
  (* mettre ss en sortie *)
  (* passer l'arduboy en mode maître *)
  (* activer le SPI *)
  (* mettre sck et mosi en sortie *)

(* Close SPI connection *)
let end_spi () =
  ()
(* desactiver le SPI *)

(* Emit data through the SPI connection *)
let transfer data =
  ()
  (* écrire dans le registre SPDR *)
  (* attendre que SPSR[SPIF] vaille 1 *)

