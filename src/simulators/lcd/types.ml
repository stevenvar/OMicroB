
type display_mode = On | Off

type ddram = int array
type matrix = bool array array


type display = {
  x : int;
  y : int;
  cs : Simul.pin;
  dc : Simul.pin;
  rst : Simul.pin;
  column_nb : int;
  line_nb : int;
  width : int;
  height : int;
  matrix : matrix;
  ddram : ddram;
  (* cgram : cgram; *)
  (* mutable ram_addr : int;
   * mutable selected_ram : ram;
   * mutable line_mode : line_mode;
   * mutable cursor_mode : cursor_mode;
   * mutable entry_mode_incr : direction;
   * mutable shift_display : bool;
   * mutable display_mode : display_mode; *)
}
