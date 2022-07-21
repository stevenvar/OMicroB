val int_of_hex1 : char -> int
val int_of_hex2 : char -> char -> int
val int_of_hex3 : char -> char -> char -> int


module type MCUSimul = sig
  type 'a pin
  type register
  type bit

  val pin_of_string : string -> [ `SIMUL ] pin
  val name_of_pin : [ `SIMUL ] pin -> string
  val nb_pins : int

  val num_of_pin : [ `SIMUL ] pin -> int
  val pin_of_num : int -> [ `SIMUL ] pin option

  val spdr : register
  val register_of_char : char -> register
  val char_of_register : register -> char
  val register_of_index : int -> register
  val index_of_register : register -> int
  val nb_registers : int

  val index_of_bit : bit -> int
  val bit_of_index : int -> bit

  val register_of_pin : [ `SIMUL ] pin -> register
  val bit_of_pin : [ `SIMUL ] pin -> bit

  val pin_of_register_bit : register -> bit -> [ `SIMUL ] pin
end


module Simul(M : MCUSimul) : sig
  open M

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
      IWrite of register * int
    | ITris of register * int
    | IWriteAnalog of an * int
    | IConfigAnalog of int
    | ISync
    | IStop
  val input_of_string : string -> input
  type output =
    | OSet of [ `SIMUL ] pin
    | OClear of [ `SIMUL ] pin
    | OWrite of register * int
    | OWriteAnalog of an * int
    | ODone
    | OStop
  val string_of_output : output -> string
  val channel : output Event.channel
  val send : output -> unit
  type handler =
    | Exit_handler of (unit -> unit)
    | Write_handler of (register -> int -> unit)
    | Write_register_handler of register * (int -> unit)
    | Tris_handler of (register -> int -> unit)
    | Tris_register_handler of register * (int -> unit)
    | Set_handler of ([ `SIMUL ] pin -> unit)
    | Clear_handler of ([ `SIMUL ] pin -> unit)
    | Change_handler of ([ `SIMUL ] pin -> bool -> unit)
    | Set_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Clear_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Change_pin_handler of [ `SIMUL ] pin * (bool -> unit)
    | Setin_handler of ([ `SIMUL ] pin -> unit)
    | Setout_handler of ([ `SIMUL ] pin -> unit)
    | Setstate_handler of ([ `SIMUL ] pin -> bool -> unit)
    | Setin_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Setout_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Setstate_pin_handler of [ `SIMUL ] pin * (bool -> unit)
    | Write_analog_handler of (an -> int -> unit)
    | Write_an_analog_handler of an * (int -> unit)
    | Config_analogs_handler of (int -> unit)
  val handlers_mutex : Mutex.t
  val handlers : handler list ref
  val add_handler : handler -> unit
  val remove_handler : handler -> unit
  val registers : int array
  val triss : int array
  val analogs : int array
  val analog_cnt : int ref
  val scall1 : ('a -> unit) -> 'a -> unit
  val scall2 : ('a -> 'b -> unit) -> 'a -> 'b -> unit
  val exec : input -> bool
  val start : unit -> unit
  val join : unit -> unit
  val write_register : register -> int -> unit
  val set_pin : [ `SIMUL ] pin -> unit
  val clear_pin : [ `SIMUL ] pin -> unit
  val change_pin : [ `SIMUL ] pin -> bool -> unit
  val write_analog : an -> int -> unit
  val read_register : register -> int
  val read_tris : register -> int
  val test_pin : [ `SIMUL ] pin -> bool
  val state_pin : [ `SIMUL ] pin -> bool
  val analog_input_count : unit -> int
end
