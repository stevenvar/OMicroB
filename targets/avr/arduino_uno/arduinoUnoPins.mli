open Avr

type register =
  | PORTB | PORTC | PORTD
  | DDRB | DDRC | DDRD
  | PINB | PINC | PIND
  | SPCR | SPSR | SPDR

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE ] pin
  | PIN1  : [< `DREAD | `DWRITE ] pin
  | PIN2  : [< `DREAD | `DWRITE ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN4  : [< `DREAD | `DWRITE ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE ] pin
  | PIN8  : [< `DREAD | `DWRITE ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN12 : [< `DREAD | `DWRITE ] pin
  | PIN13 : [< `DREAD | `DWRITE ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | SS    : [< `SS ] pin
  | PINA0 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA1 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA2 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA3 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA4 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA5 : [< `DREAD | `DWRITE | `AREAD ] pin

include AvrPins
  with type register := register
  with type 'a pin := 'a pin
