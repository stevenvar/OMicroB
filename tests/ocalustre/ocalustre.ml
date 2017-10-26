module Arduboy = struct
  type button = A | B | UP | DOWN | LEFT | RIGHT
  external millis : unit -> int = "ocaml_arduboy_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external clear : unit -> unit = "ocaml_arduboy_clear"
end

type ('a,'b) count_state =
  {
  mutable count_pre_c: 'a ;
  mutable count_out_c: 'b }

let count_init init =
  let c = init  in
  let pre_c = c + 1  in { count_pre_c = pre_c; count_out_c = c } 

let count_step state init =
  let c = state.count_pre_c  in
  let pre_c = c + 1  in
  state.count_out_c <- c; state.count_pre_c <- pre_c; () 


let _ = 
  Arduboy.init ();
  let x = Arduboy.millis () in 
  let counter_state = count_init 0 in 
  (* Arduboy.print_int counter_state.count_out_c; *)
  for i = 0 to 99 do 
    count_step counter_state 0;
    (* Arduboy.print_int counter_state.count_out_c; *)
  done;
  let y = Arduboy.millis () -x in 
  Arduboy.print("\n");
  Arduboy.print_int y;
  Arduboy.display()
  
