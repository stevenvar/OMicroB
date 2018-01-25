open Avr
open Arduboy
type direction = North | South | East | West

let _ =  Random.init 42

let snake = Array.make 20 (0,0)
let ptr_head = ref 1
let ptr_tail = ref 0
let size = ref 1

exception Lose
exception Win

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


let button_direction =
  let old_left = ref HIGH in
  let old_right = ref HIGH in
  fun dir -> 
  let new_left = digital_read button_left in
  let new_right = digital_read button_right in 
  let new_dir = 
  match new_left,new_right with
  | LOW,_ when !old_left <> LOW -> left_of dir
  | _ , LOW  when !old_right <> LOW -> right_of dir
  | _ -> dir
  in
  old_left := new_left;
  old_right := new_right;
  new_dir

exception Break
let collides_with_itself () =
  let i = ref !ptr_tail in
  try
  while true do
    if !i = !ptr_head then raise Break;
    if snake.(!i) = snake.(!ptr_head) then
      raise Lose;
    incr i;
    i := !i mod Array.length snake;
  done
  with Break -> ()

(* Generated code *)
let rising_edge in_f =
  let st__aux_1 = ref false  in
  let rising_edge_step in_f =
    let _aux_1 = !st__aux_1  in
    let out_f = in_f && (not _aux_1)  in st__aux_1 := in_f; out_f  in
  rising_edge_step
let new_dir (dir,left,right) =
  let new_dir_step (dir,left,right) =
    let n_d =
      if left
      then
        (if dir = South
         then East
         else
           if dir = North then West else if dir = East then North else South)
      else
        if right
        then
          (if dir = South
           then West
           else
             if dir = North
             then East
             else if dir = East then South else North)
        else dir
       in
    n_d  in
  new_dir_step 
let new_x (dir,x) =
  let new_x_step (dir,x) =
    let n_x =
      if dir = West
      then ((x - 1) + 64) mod 64
      else if dir = East then ((x + 1) + 64) mod 64 else x  in
    n_x  in
  new_x_step 
let new_y (dir,y) =
  let new_y_step (dir,y) =
    let n_y =
      if dir = North
      then ((y - 1) + 32) mod 32
      else if dir = South then ((y + 1) + 32) mod 32 else y  in
    n_y  in
  new_y_step 

let new_head (b1,b2) =
  let st_y = ref 0  in
  let st_x = ref 1  in
  let st_dir = ref South  in
  let st_left = ref false  in
  let st_right = ref false  in
  let dir = !st_dir  in
  let left = !st_left  in
  let right = !st_right  in
  let x = !st_x  in
  let y = !st_y  in
  let new_y5_step = new_y (dir, y)  in
  let new_x4_step = new_x (dir, x)  in
  let new_dir3_step = new_dir (dir, left, right)  in
  let rising_edge2_step = rising_edge b2  in
  let rising_edge1_step = rising_edge b1  in
  let new_head_step (b1,b2) =
    let _aux_1 = rising_edge1_step b1  in
    let _aux_2 = rising_edge2_step b2  in
    let right = !st_right  in
    let left = !st_left  in
    let dir = !st_dir  in
    let _aux_3 = new_dir3_step (dir, left, right)  in
    let x = !st_x  in
    let _aux_4 = new_x4_step (dir, x)  in
    let y = !st_y  in
    let _aux_5 = new_y5_step (dir, y)  in
    st_right := _aux_2;
    st_left := _aux_1;
    st_dir := _aux_3;
    st_x := _aux_4;
    st_y := _aux_5;
    (x, y)  in
  new_head_step 
(* . *)

let draw_apple () =
  let x,y = !apple in
  Oled.draw x y true

let bip () =
  pin_mode PIN13 OUTPUT;
  pin_mode PIN5 OUTPUT;
  for _i = 1 to 1_000 do
    digital_write PIN13 HIGH;
    digital_write PIN5 LOW;
    digital_write PIN13 LOW;
    digital_write PIN5 HIGH;
  done

let eats_apple () =
  bip ();
  snake.(!ptr_head) = (!apple)

let new_head_step = new_head (false,false)

let bol = function
  | HIGH -> true
  | LOW -> false

let lob = function
  | true -> HIGH
  | false -> LOW

let game_loop ()=
  while true do 
  let (xh,yh) as head = new_head_step (not (bol (digital_read button_left)),not (bol (digital_read button_right))) in
  let (xt,yt) = (snake.(!ptr_tail)) in
  (* let new_dir = button_direction  in *)
  if (eats_apple ()) then
    begin
      apple := new_position ();
      incr size;
      if !size = Array.length snake then 
        raise Win;
    end
  else 
     begin
      Oled.draw xt yt false;
      ptr_tail := (!ptr_tail + 1) mod (Array.length snake)
    end;
  ptr_head := (!ptr_head + 1) mod (Array.length snake);
  snake.(!ptr_head) <- head;
  draw_apple ();
  Oled.draw xh yh true;
  Oled.display ();
  collides_with_itself ();
  delay(100 - !size);
done

let () = 
  init ();
  try
    game_loop ()
  with Lose ->
    digital_write r LOW
     | Win ->
     digital_write g LOW
