open Avr
open Arduboy
type direction = North | South | East | West

let _ =  Random.init 10
let snake = Array.make 10 (0,0)
(* let apple = ref (Random.int 63,Random.int 31) *)
let apple = ref (20,20)

let ptr_head = ref 1
let ptr_tail = ref 0

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
  let dr = digital_read in
  match (dr button_left, dr button_right) with
  | LOW,_ -> left_of dir
  | _ , LOW -> right_of dir
  | _ -> dir

let max x y = if x > y then x else y

let new_head dir =
  let (cx,cy) = snake.(!ptr_head) in
  match dir with
  | South -> (cx,(cy+1) mod 32)
  | North -> (cx,(cy - 1 + 32) mod 32)
  | West -> ((cx-1 + 64) mod 64,cy)
  | East -> ((cx+1) mod 64,cy)

let draw_snake () =
  if !ptr_tail < !ptr_head then
    for i = !ptr_tail to !ptr_head do
      let (x,y) = snake.(i) in
      Oled.draw x y true;
    done
  else
    begin
      for i = !ptr_tail to Array.length snake - 1 do
        let (x,y) = snake.(i) in
        Oled.draw x y true;
      done;
      for i = 0 to !ptr_head do
        let (x,y) = snake.(i) in
        Oled.draw x y true;
      done
    end

let draw_apple () =
  let x,y = !apple in
  Oled.draw x y true

let eats_apple () =
  let xa,ya = !apple in
  let x,y = snake.(0) in
  x = xa && y = ya

let eats_apple () =
  snake.(!ptr_head) = !apple

let rec game_loop dir=
  let head = new_head dir in
  let (xt,yt) = snake.(!ptr_tail) in
  let new_dir = button_direction dir in
  ptr_head := (!ptr_head + 1) mod (Array.length snake);
  if (not (eats_apple ())) then
      (Oled.draw xt yt false;
       ptr_tail := (!ptr_tail + 1) mod (Array.length snake));
  snake.(!ptr_head) <- head;
  draw_snake ();
  draw_apple ();
  (* sleep 2000; *)
  Oled.display ();
  delay(100);
  game_loop new_dir

let () =
  init ();
  game_loop South
