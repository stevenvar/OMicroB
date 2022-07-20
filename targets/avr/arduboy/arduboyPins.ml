type register =
  | PORTB | PORTC | PORTD | PORTE | PORTF
  | DDRB | DDRC | DDRD | DDRE | DDRF
  | PINB | PINC | PIND | PINE | PINF
  | SPCR | SPSR | SPDR

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

type 'a pin =
  | PIN2  : [< `CART_CS ] pin
  | PIN4  : [< `OLED_DC | `DWRITE ] pin
  | PIN5  : [< `SPEAKER_PLUS ] pin
  | PIN6  : [< `OLED_RST | `DWRITE ] pin
  | PIN7  : [< `BUTTON_A | `DREAD ] pin
  | PIN8  : [< `BUTTON_B | `DREAD ] pin
  | PIN9  : [< `LED_BLUE | `DWRITE ] pin
  | PIN10 : [< `LED_RED | `DWRITE ] pin
  | PIN12 : [< `OLED_CS | `DWRITE ] pin
  | PIN11 : [< `LED_GREEN | `DWRITE ] pin
  | PIN13 : [< `SPEAKER_MINUS ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | SS    : [< `SS ] pin
  | PINA0 : [< `BUTTON_UP | `DREAD ] pin
  | PINA1 : [< `BUTTON_RIGHT | `DREAD ] pin
  | PINA2 : [< `BUTTON_LEFT | `DREAD ] pin
  | PINA3 : [< `BUTTON_DOWN | `DREAD ] pin

let port_of_pin : type a. a pin -> register =
  function
  | PIN2 -> PORTD
  | PIN4 -> PORTD
  | PIN5 -> PORTC
  | PIN6 -> PORTD
  | PIN7 -> PORTE
  | PIN8 -> PORTB
  | PIN9 -> PORTB
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTD
  | PIN13 -> PORTC
  | MISO -> PORTB
  | SCK -> PORTB
  | MOSI -> PORTB
  | SS -> PORTB
  | PINA0 -> PORTF
  | PINA1 -> PORTF
  | PINA2 -> PORTF
  | PINA3 -> PORTF

let ddr_of_pin : type a. a pin -> register =
  function
  | PIN2 -> DDRD
  | PIN4 -> DDRD
  | PIN5 -> DDRC
  | PIN6 -> DDRD
  | PIN7 -> DDRE
  | PIN8 -> DDRB
  | PIN9 -> DDRB
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRD
  | PIN13 -> DDRC
  | MISO -> DDRB
  | SCK -> DDRB
  | MOSI -> DDRB
  | SS -> DDRB
  | PINA0 -> DDRF
  | PINA1 -> DDRF
  | PINA2 -> DDRF
  | PINA3 -> DDRF

let input_of_pin : type a. a pin -> register =
  function
  | PIN2 -> PIND
  | PIN4 -> PIND
  | PIN5 -> PINC
  | PIN6 -> PIND
  | PIN7 -> PINE
  | PIN8 -> PINB
  | PIN9 -> PINB
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PIND
  | PIN13 -> PINC
  | MISO -> PINB
  | SCK -> PINB
  | MOSI -> PINB
  | SS -> PINB
  | PINA0 -> PINF
  | PINA1 -> PINF
  | PINA2 -> PINF
  | PINA3 -> PINF

let port_bit_of_pin : type a. a pin -> bit =
  function
  | PIN2 -> BIT1
  | PIN4 -> BIT4
  | PIN5 -> BIT6
  | PIN6 -> BIT7
  | PIN7 -> BIT6
  | PIN8 -> BIT4
  | PIN9 -> BIT5
  | PIN10 -> BIT6
  | PIN11 -> BIT7
  | PIN12 -> BIT6
  | PIN13 -> BIT7
  | MISO -> BIT3
  | SCK -> BIT1
  | MOSI -> BIT2
  | SS -> BIT0
  | PINA0 -> BIT7
  | PINA1 -> BIT6
  | PINA2 -> BIT5
  | PINA3 -> BIT4

let ddr_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
let input_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
