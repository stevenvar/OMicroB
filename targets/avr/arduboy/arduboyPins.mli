open Avr

type register =
  | PORTB | PORTC | PORTD | PORTE | PORTF
  | DDRB | DDRC | DDRD | DDRE | DDRF
  | PINB | PINC | PIND | PINE | PINF
  | SPCR | SPSR | SPDR
type 'a pin =
  | PIN2  : [< `CART_CS ] pin
  | PIN4  : [< `OLED_DC ] pin
  | PIN5  : [< `SPEAKER_PLUS ] pin
  | PIN6  : [< `OLED_RST ] pin
  | PIN7  : [< `BUTTON_A | `DREAD ] pin
  | PIN8  : [< `BUTTON_B | `DREAD ] pin
  | PIN9  : [< `LED_BLUE | `DWRITE ] pin
  | PIN10 : [< `LED_RED | `DWRITE ] pin
  | PIN12 : [< `OLED_CS ] pin
  | PIN11 : [< `LED_GREEN | `DWRITE ] pin
  | PIN13 : [< `SPEAKER_MINUS ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | PINA0 : [< `BUTTON_UP | `DREAD ] pin
  | PINA1 : [< `BUTTON_RIGHT | `DREAD ] pin
  | PINA2 : [< `BUTTON_LEFT | `DREAD ] pin
  | PINA3 : [< `BUTTON_DOWN | `DREAD ] pin
include AvrPins
  with type register := register
  with type 'a pin := 'a pin
