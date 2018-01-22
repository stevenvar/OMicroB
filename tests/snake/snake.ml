open Avr

let cs = PIN12 
let dc = PIN4 
let rst = PIN6
let button_left = PINA2 
let button_right = PINA1
let button_down = PINA3 
let button_up = PINA0 
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
  pin_mode button_down INPUT_PULLUP;
  pin_mode button_up INPUT_PULLUP;
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

let snake = Array.make 20 (0,0)

(* let current_dir = ref South *)

let button_direction dir =
  let dr = digital_read in
  match (dr button_up, dr button_down, dr button_left, dr button_right) with
  | LOW,_,_,_ when dir <> South -> North
  | _ , LOW, _,_ when dir <> North -> South
  | _, _, LOW, _ when dir <> East -> West
  | _, _, _ , LOW when dir <> West -> East
  | _ -> dir

let max x y = if x > y then x else y


let new_head dir =
  let (cx,cy) = snake.(0) in 
  match dir with
  | South -> (cx,(cy+1) mod 32)
  | North -> (cx,(if cy-1 < 0 then 31 else cy-1))
  | West -> ((if cx-1 < 0 then 63 else cx-1),cy)
  | East -> ((cx+1) mod 64,cy)

let apple = ref (10,10)

exception Break

let draw_snake upto =
  (* try *)
    (* Array.iteri (fun i (x,y) -> if i > upto then raise Break else Oled.draw x y true) snake *)
  (* with Break -> ()  *)
  for i = 0 to upto do
    let (x,y) = snake.(i) in
    Oled.draw x y true
  done

let draw_apple () =
  let x,y = !apple in 
  Oled.draw x y true


let shift_right array =
  let x,y = array.(10) in
  Oled.draw x y false;
  for i = Array.length array -1 downto 1 do
    array.(i) <- array.(i-1)
  done

let rec game_loop dir i =
  if i = 0 then ()
  else (
    draw_snake 10;
    draw_apple ();
    Oled.display ();
  let head = new_head dir in
  shift_right snake;
  snake.(0) <- head;
  (* remove_tail (); *)
  (* sleep 1000; *)
  game_loop (button_direction dir) (i))
  
let init () =
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:cs ~dc:dc ~rst:rst
    
let () =
  init ();
  for i = 0 to 10 do
    snake.(10-i) <- (0,i);
  done;
  game_loop South 10
