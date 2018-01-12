type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPIF | WCOL | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPI2x
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7

type mode_register = DDRB | DDRC | DDRD | DDRE
type input_port = PINB | PINC | PIND | PINE
type output_port = PORTB | PORTC | PORTD | PORTE
            
type 'a register =
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register
        
type mode = INPUT | OUTPUT | INPUT_PULLUP

type direction = LSB_first | MSB_first

type pin =
| PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
| PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
| PIN15 | PIN16 | PIN17

external write_register : 'a register -> int -> unit = "caml_avr_write_register"
external read_register : 'a register -> int = "caml_avr_read_register"
external digital_write : pin -> bool -> unit = "caml_avr_digital_write"
external set_bit : 'a register -> 'a -> unit = "caml_avr_set_bit"
external clear_bit : 'a register -> 'a -> unit = "caml_avr_clear_bit"
external read_bit : 'a register -> 'a -> bool = "caml_avr_read_bit"
external port_mode : 'a register -> mode -> unit = "caml_avr_port_mode"
external pin_mode : pin -> mode -> unit = "caml_avr_port_mode"

