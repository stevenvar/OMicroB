open Avr

type register =
  | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG | PORTH | PORTJ | PORTK | PORTL
  | DDRA | DDRB | DDRC | DDRD | DDRE | DDRF | DDRG | DDRH | DDRJ | DDRK | DDRL
  | PINA | PINB | PINC | PIND | PINE | PINF | PING | PINH | PINJ | PINK | PINL
  | SPCR | SPSR | SPDR

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE ] pin
  | PIN1  : [< `DREAD | `DWRITE ] pin
  | PIN2  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN4  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN8  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN12 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN13 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN14 : [< `DREAD | `DWRITE ] pin
  | PIN15 : [< `DREAD | `DWRITE ] pin
  | PIN16 : [< `DREAD | `DWRITE ] pin
  | PIN17 : [< `DREAD | `DWRITE ] pin
  | PIN18 : [< `DREAD | `DWRITE ] pin
  | PIN19 : [< `DREAD | `DWRITE ] pin
  | PIN20 : [< `DREAD | `DWRITE ] pin
  | PIN21 : [< `DREAD | `DWRITE ] pin
  | PIN22 : [< `DREAD | `DWRITE ] pin
  | PIN23 : [< `DREAD | `DWRITE ] pin
  | PIN24 : [< `DREAD | `DWRITE ] pin
  | PIN25 : [< `DREAD | `DWRITE ] pin
  | PIN26 : [< `DREAD | `DWRITE ] pin
  | PIN27 : [< `DREAD | `DWRITE ] pin
  | PIN28 : [< `DREAD | `DWRITE ] pin
  | PIN29 : [< `DREAD | `DWRITE ] pin
  | PIN30 : [< `DREAD | `DWRITE ] pin
  | PIN31 : [< `DREAD | `DWRITE ] pin
  | PIN32 : [< `DREAD | `DWRITE ] pin
  | PIN33 : [< `DREAD | `DWRITE ] pin
  | PIN34 : [< `DREAD | `DWRITE ] pin
  | PIN35 : [< `DREAD | `DWRITE ] pin
  | PIN36 : [< `DREAD | `DWRITE ] pin
  | PIN37 : [< `DREAD | `DWRITE ] pin
  | PIN38 : [< `DREAD | `DWRITE ] pin
  | PIN39 : [< `DREAD | `DWRITE ] pin
  | PIN40 : [< `DREAD | `DWRITE ] pin
  | PIN41 : [< `DREAD | `DWRITE ] pin
  | PIN42 : [< `DREAD | `DWRITE ] pin
  | PIN43 : [< `DREAD | `DWRITE ] pin
  | PIN44 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN45 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN46 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN47 : [< `DREAD | `DWRITE ] pin
  | PIN48 : [< `DREAD | `DWRITE ] pin
  | PIN49 : [< `DREAD | `DWRITE ] pin
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
  | PINA6 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA7 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA8 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA9 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA10 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA11 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA12 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA13 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA14 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA15 : [< `DREAD | `DWRITE | `AREAD ] pin
include AvrPins
  with type register := register
  with type 'a pin := 'a pin
