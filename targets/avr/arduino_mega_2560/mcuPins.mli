open Avr
open ArduinoMegaPins

include AvrPins
  with type register := register
  with type 'a pin := 'a pin

module MCUConnection: Circuits.MCUConnection with type 'a pin = 'a pin with type level = level
