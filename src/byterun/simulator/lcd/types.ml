
type line_mode = One | Two
type display_mode = On | Off
type cursor_mode = Show | Hide | Blink
type bus_mode = Eight | Four
type direction = Left | Right
type font = F5x8 | F5x11
type ram = DDRam | CGRam

type ddram = char array
type cgram = bool array array array
type matrix = bool array array array array

type display = {
  x : int;
  y : int;
  e : Simul.pin;
  rs : Simul.pin;
  rw : Simul.pin;
  bus : Simul.port;
  column_nb : int;
  line_nb : int;
  width : int;
  height : int;
  matrix : matrix;
  ddram : ddram;
  cgram : cgram;
  mutable ram_addr : int;
  mutable selected_ram : ram;
  mutable line_mode : line_mode;
  mutable cursor_mode : cursor_mode;
  mutable entry_mode_incr : direction;
  mutable shift_display : bool;
  mutable display_mode : display_mode;
  mutable font : font;
  mutable bus_mode : bus_mode;
}
