open Avr
open Arduboy
type direction = North | South | East | West

let _ =  Random.init 10
let snake = Array.make 20 (0,0)
let ptr_head = ref 3
let ptr_tail = ref 0

let size = ref 3

(* exception Lose *)
(* exception Win *)


let new_position () =
  (Random.int 64, Random.int 32)

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

let button_direction dir =
  match (digital_read button_left, digital_read button_right) with
  | LOW,_ -> left_of dir
  | _ , LOW -> right_of dir
  | _ -> dir

let collides_with_itself () = ()
  (* for i = !ptr_tail to !ptr_head-1 do *)
    (* if snake.(!ptr_head) = snake.(i) then *)
      (* raise Lose *)
  (* done *)

let new_head dir =
  let (cx,cy) = snake.(!ptr_head) in
  match dir with
  | South -> (cx,(cy+1) mod 32)
  | North -> (cx,(cy - 1 + 32) mod 32)
  | West -> ((cx-1 + 64) mod 64,cy)
  | East -> ((cx+1) mod 64,cy)

let draw_apple () =
  let x,y = !apple in
  Oled.draw x y true

let eats_apple () =
  snake.(!ptr_head) = !apple

let rec game_loop dir=
  let (xh,yh) as head = new_head dir in
  let (xt,yt) = snake.(!ptr_tail) in
  let new_dir = button_direction dir in
  if (not (eats_apple ())) then
    begin
      Oled.draw xt yt false;
       ptr_tail := (!ptr_tail + 1) mod (Array.length snake)
    end
  else(
    apple := new_position ();
    incr size;
    (* if !size = Array.length snake then ()  raise Win; *)
  );
  ptr_head := (!ptr_head + 1) mod (Array.length snake);
  snake.(!ptr_head) <- head;
  Oled.draw xh yh true;
  draw_apple ();
  Oled.display ();
  delay(100);
  collides_with_itself ();
  game_loop new_dir

let () =
  init ();
  (* try *)
    game_loop South
  (* with Lose -> *)
    (* digital_write r LOW *)
     (* | Win -> *)
     (* digital_write g LOW *)
