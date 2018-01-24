open Avr
open Arduboy
type direction = North | South | East | West

let snake = Array.make 20 (0,0)
let ptr_head = ref 1
let ptr_tail = ref 0
let size = ref 1

exception Lose
exception Win

let new_position () = (10,10)
  (* TODO *)
 
let apple = ref (new_position ())

let left_of = function
    South -> East
  | North -> West
  | East -> North
  | West -> South

let right_of = function
    South -> West
  | North -> East
  | East -> South
  | West -> North

let button_direction dir = North
  (* TODO *)



let collides_with_itself () = ()
  (* TODO *)

  

let new_head dir =
  let (x,y) = snake.(!ptr_head) in
  match dir with
  | South -> (* TODO *) (0,0)
  | North -> (* TODO *) (0,0)
  | West -> (* TODO *) (0,0) 
  | East -> (* TODO *) (0,0)

let draw_apple () =
  let x,y = !apple in
  Oled.draw x y true

let eats_apple () = false
(* TODO *)

let rec game_loop dir=
  let (xh,yh) as head = new_head dir in
  let (xt,yt) = (snake.(!ptr_tail)) in
  let new_dir = button_direction dir in
  if (eats_apple ()) then
    begin
    (* TODO *)
      ()
    end
  else
    begin
    (* TODO *)
      ()
    end
  ;
  (* TODO : mettre à jour le pointeur de tête *)
  snake.(!ptr_head) <- head;
  (* TODO : afficher tête *)
  draw_apple ();
  Oled.display ();
  collides_with_itself ();
  delay(100 - !size); (* on accélère + le serpent est long *)
  game_loop new_dir

let () = 
  init ();
  try
    game_loop South
  with Lose ->
    digital_write r LOW
     | Win ->
     digital_write g LOW
