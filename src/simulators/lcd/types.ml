
type ddram = int array

type cgram = bool array array array
type matrix = bool array array

type mode = Data | Command

module DisplayTypes(M : Simul.MCUSimul) = struct
  open M

  type display = {
    x : int;
    y : int;
    cs : [ `SIMUL ] pin;
    dc : [ `SIMUL ] pin;
    rst : [ `SIMUL ] pin;
    register : register;
    column_nb : int;
    line_nb : int;
    width : int;
    height : int;
    matrix : matrix;
    ddram : ddram;
    mutable mode : mode;
    mutable current_col : int;
    mutable current_page : int;
    mutable min_col : int;
    mutable max_col : int;
    mutable min_page : int;
    mutable max_page : int;
    (* cgram : cgram; *)
    (* mutable ram_addr : int;
     * mutable selected_ram : ram;
     * mutable line_mode : line_mode;
     * mutable cursor_mode : cursor_mode;
     * mutable entry_mode_incr : direction;
     * mutable shift_display : bool;
     * mutable display_mode : display_mode; *)
  }


  type line_mode = One | Two
  type display_mode = On | Off
  type cursor_mode = Show | Hide | Blink
  type bus_mode = Eight | Four
  type direction = Left | Right
  type font = F5x8 | F5x11
  type ram = DDRam | CGRam


  type display16x2 = {
    x16 : int;
    y16 : int;
    e : [ `SIMUL ] pin;
    rs : [ `SIMUL ] pin;
    rw : [ `SIMUL ] pin;
    d4 : [ `SIMUL ] pin;
    d5 : [ `SIMUL ] pin;
    d6 : [ `SIMUL ] pin;
    d7 : [ `SIMUL ] pin;
    column_nb16 : int;
    line_nb16 : int;
    width16 : int;
    height16 : int;
    matrix16 : matrix;
    ddram16 : ddram;
    cgram : cgram;
    mutable ram_addr : int;
    mutable selected_ram : ram;
    mutable line_mode : line_mode;
    mutable cursor_mode : cursor_mode;
    mutable entry_mode_incr : direction;
    mutable shift_display : bool;
    mutable display_mode : display_mode;
  }
end
