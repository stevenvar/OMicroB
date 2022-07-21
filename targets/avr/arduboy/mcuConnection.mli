open Avr
open ArduboyPins

include AvrPins
  with type register := register
  with type bit := bit
  with type 'a pin := 'a pin
