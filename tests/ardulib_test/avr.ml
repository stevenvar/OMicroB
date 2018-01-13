type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPIF | WCOL | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPI2x
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7
            
type 'a register =
  | PORTD : portd_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register
        
external write_register : 'a register -> int -> unit = "caml_avr_write_register"
external read_register : 'a register -> int = "caml_avr_read_register"
external digital_write : pin -> bool -> unit = "caml_avr_digital_write"
external set_bit : 'a register -> 'a -> unit = "caml_avr_set_bit"
external clear_bit : 'a register -> 'a -> unit = "caml_avr_clear_bit"
external read_bit : 'a register -> 'a -> bool = "caml_avr_read_bit"
external pin_mode : pin -> mode -> unit = "caml_pin_mode"
