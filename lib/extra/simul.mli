val int_of_hex1 : char -> int
val int_of_hex2 : char -> char -> int
val int_of_hex3 : char -> char -> char -> int
type port = PORTB | PORTC | PORTD | PORTE | PORTF
val string_of_port : port -> string
val port_of_string : string -> port
val char_of_port : port -> char
val port_of_char : char -> port
val index_of_port : port -> int
val port_of_index : int -> port
type pin =
    RB0
  | RB1
  | RB2
  | RB3
  | RB4
  | RB5
  | RB6
  | RB7
  | RC0
  | RC1
  | RC2
  | RC3
  | RC4
  | RC5
  | RC6
  | RC7
  | RD0
  | RD1
  | RD2
  | RD3
  | RD4
  | RD5
  | RD6
  | RD7
  | RE0
  | RE1
  | RE2
  | RE3
  | RE4
  | RE5
  | RE6
  | RE7
  | RF0
  | RF1
  | RF2
  | RF3
  | RF4
  | RF5
  | RF6
  | RF7
val string_of_pin : pin -> string
val port_of_pin : pin -> port
val index_of_pin : pin -> int
val pin_of_port_index : port -> int -> pin
val pin_of_string : string -> pin
type an =
    AN0
  | AN1
  | AN2
  | AN3
  | AN4
  | AN5
  | AN6
  | AN7
  | AN8
  | AN9
  | AN10
  | AN11
  | AN12
val string_of_an : an -> string
val an_of_string : string -> an
val char_of_an : an -> char
val an_of_char : char -> an
val int_of_an : an -> int
val an_of_int : int -> an
type input =
    IWrite of port * int
  | ITris of port * int
  | IWriteAnalog of an * int
  | IConfigAnalog of int
  | ISync
  | IStop
val input_of_string : string -> input
type output =
    OSet of pin
  | OClear of pin
  | OWrite of port * int
  | OWriteAnalog of an * int
  | ODone
  | OStop
val string_of_output : output -> string
val channel : output Event.channel
val send : output -> unit
type handler =
    Exit_handler of (unit -> unit)
  | Write_handler of (port -> int -> unit)
  | Write_port_handler of port * (int -> unit)
  | Tris_handler of (port -> int -> unit)
  | Tris_port_handler of port * (int -> unit)
  | Set_handler of (pin -> unit)
  | Clear_handler of (pin -> unit)
  | Change_handler of (pin -> bool -> unit)
  | Set_pin_handler of pin * (unit -> unit)
  | Clear_pin_handler of pin * (unit -> unit)
  | Change_pin_handler of pin * (bool -> unit)
  | Setin_handler of (pin -> unit)
  | Setout_handler of (pin -> unit)
  | Setstate_handler of (pin -> bool -> unit)
  | Setin_pin_handler of pin * (unit -> unit)
  | Setout_pin_handler of pin * (unit -> unit)
  | Setstate_pin_handler of pin * (bool -> unit)
  | Write_analog_handler of (an -> int -> unit)
  | Write_an_analog_handler of an * (int -> unit)
  | Config_analogs_handler of (int -> unit)
val handlers_mutex : Mutex.t
val handlers : handler list ref
val add_handler : handler -> unit
val remove_handler : handler -> unit
val ports : int array
val triss : int array
val analogs : int array
val analog_cnt : int ref
val scall1 : ('a -> unit) -> 'a -> unit
val scall2 : ('a -> 'b -> unit) -> 'a -> 'b -> unit
val exec : input -> bool
val start : unit -> unit
val join : unit -> unit
val write_port : port -> int -> unit
val set_pin : pin -> unit
val clear_pin : pin -> unit
val change_pin : pin -> bool -> unit
val write_analog : an -> int -> unit
val read_port : port -> int
val read_tris : port -> int
val test_pin : pin -> bool
val state_pin : pin -> bool
val analog_input_count : unit -> int
