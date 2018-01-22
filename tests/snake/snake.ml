open Avr

let cs = PIN12
let dc = PIN4
let rst = PIN6
let button_left = PINA2
let button_right = PINA1
(* let button_down = PINA3 *)
(* let button_up = PINA0 *)
let button_a = PIN7
let button_b = PIN8
let g = PIN9
let r = PIN10
let b = PIN11


let init_rgb r g b =
  digital_write r HIGH;
  digital_write g HIGH;
  digital_write b HIGH

let boot_pins () =
  pin_mode button_left INPUT_PULLUP;
  pin_mode button_right INPUT_PULLUP;
  (* pin_mode button_down INPUT_PULLUP; *)
  (* pin_mode button_up INPUT_PULLUP; *)
  pin_mode r OUTPUT;
  pin_mode g OUTPUT;
  pin_mode b OUTPUT;
  pin_mode button_a INPUT_PULLUP;
  pin_mode button_b INPUT_PULLUP;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  init_rgb r g b

let sleep x =
  for i = 0 to x do
    for _j = 0 to x do
      ();
    done
  done

type direction = North | South | East | West

let snake = Array.make 10 (0,0)
let ptr_head = ref 1
let ptr_tail = ref 0

(* let current_dir = ref South *)

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
  | North -> (cx,(if cy-1 < 0 then 31 else cy-1))
  | West -> ((if cx-1 < 0 then 63 else cx-1),cy)
  | East -> ((cx+1) mod 64,cy)

let apple = ref (10,10)

let size = ref 1

exception Break

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


  (* try
   *   Array.iteri (fun i (x,y) -> if i > !ptr_head then raise Break else if i > !ptr_tail then Oled.draw x y true) snake
   * with Break -> ()
   * (\* for i = 0 to upto do *\)
   *   (\* let (x,y) = snake.(i) in *\)
   *   (\* Oled.draw x y true *\)
   * (\* done *\) *)

let draw_apple () =
  let x,y = !apple in
  Oled.draw x y true

let eats_apple () =
  let xa,ya = !apple in
  let x,y = snake.(0) in
  x = xa && y = ya


let remove_tail () =
  let x,y = snake.(!size+1) in
  Oled.draw x y false


let shift_right array =

  for i = Array.length array -1 downto 1 do
    array.(i) <- array.(i-1)
  done

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

let init () =
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:cs ~dc:dc ~rst:rst

let () =
  init ();
  game_loop South
