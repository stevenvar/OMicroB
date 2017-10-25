module Array = struct 
  external length : 'a array -> int = "%array_length"
  external get: 'a array -> int -> 'a = "%array_safe_get"
  external set: 'a array -> int -> 'a -> unit = "%array_safe_set"
  external make: int -> 'a -> 'a array = "caml_make_vect"
end;;

module Arduboy = struct
  (* external reset_cursor : unit -> unit = "ocaml_arduboy_reset_cursor" *)
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end

open Arduboy


type cell = Morte | Vivante

let grid = 
  [|
    [| Morte; Morte ; Morte ; Morte ; Morte |];
    [| Morte; Morte ; Morte ; Morte ; Morte |];
    [| Morte; Morte ; Vivante ; Morte ; Morte |];
    [| Morte; Morte ; Morte ; Morte ; Morte |];
    [| Morte; Morte ; Morte ; Morte ; Morte |];
  |]
  
let print_cell = function 
  | Morte -> print_string "x"
  | Vivante -> print_string "o"

let next_gen_cell x y g = 
  match g.(x).(y) with 
  | Morte -> g.(x).(y) <- Vivante
  | Vivante -> g.(x).(y) <- Morte

let next_gen g = 
  for x = 0 to 4 do 
    for y = 0 to 4 do 
      next_gen_cell x y g
    done;
  done

let print_grid g = 
  for x = 0 to 4 do 
    for y = 0 to 4 do 
      print_cell g.(x).(y)
    done;
    print_string "\n";
  done

let () =
  Arduboy.init ();
  while true do
    Arduboy.clear();
    (* Arduboy.reset_cursor(); *)
    print_grid grid;
    Arduboy.display();
    next_gen  grid;
    for i = 0 to 10000 do () done;
  done
