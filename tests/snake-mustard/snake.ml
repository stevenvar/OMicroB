exception Win
exception Lose

type direction = North | South | East | West

let width  = 128
let height = 64
    
type t = {
  positions : int array;
  length    : int;
  mutable head      : int;
  mutable tail      : int;
  mutable direction : direction;
}

let merge x y = (x lsl 8) lor y        (* Merge abscissa and ordinate into a position encoded as a signle integer *)
let getx pos = pos lsr 8               (* Retrieve the abscissa of a position *)
let gety pos = pos land 0xFF           (* Retrieve the ordinate of a position *)
let cell pos = pos land 0xFFF8         (* Compute an integer representing the 8-pixel cell *)
let mask pos = 1 lsl (pos land 0b111)  (* Compute a mask for one of the 8 pixels of a cell *)
let line cell = (cell lsr 3) land 0x1F (* Compute the line of a cell (from 0 to 7) *)
let column cell = cell lsr 8           (* Compute the column of a cell (from 0 to 63) *)
  
let next pos direction =
  let x = getx pos and y = gety pos in
  match direction with
  | North -> merge x (if y = 0 then height - 1 else y - 1)
  | South -> merge x (if y = height - 1 then 0 else y + 1)
  | East  -> merge (if x = 0 then width - 1 else x - 1) y
  | West  -> merge (if x = width - 1 then 0 else x + 1) y
  
let create length x y init_len direction =
  let positions = Array.make length 0 in
  let head = init_len in
  let tail = 0 in
  positions.(0) <- merge x y;
  for i = 0 to init_len do
    positions.(i + 1) <- next positions.(i) direction;
  done;
  { positions; length; head; tail; direction }

let iter callback snake =
  if snake.tail <= snake.head then (
    for i = snake.tail to snake.head do
      callback snake.positions.(i);
    done
  ) else (
    for i = snake.tail to snake.length - 1 do
      callback snake.positions.(i);
    done;
    for i = 0 to snake.head do
      callback snake.positions.(i);
    done;
  )

let rec create_apple snake =
  let x = Random.int width  in
  let y = Random.int height in
  let pos = merge x y in
  match iter (fun p -> if p = pos then raise Exit) snake with (* Is the chosen apple inside the snake? *)
  | () -> pos                            (* No, ok, choose it *)
  | exception Exit -> create_apple snake (* Yes, retry *)

let move apple snake =
  let old_tail_ind = snake.tail in
  let old_head_ind = snake.head in
  let new_tail_ind = (old_tail_ind + 1) mod snake.length in
  let new_head_ind = (old_head_ind + 1) mod snake.length in
  let old_head_pos = snake.positions.(old_head_ind) in
  let new_head_pos = next old_head_pos snake.direction in
  let old_apple_pos = !apple in
  if new_head_pos = old_apple_pos then (
    if new_head_ind = old_tail_ind then raise Win;
    snake.head <- new_head_ind;
    snake.positions.(new_head_ind) <- new_head_pos;
    let new_apple_pos = create_apple snake in
    let new_apple_cell = cell new_apple_pos in
    let data = ref (mask new_apple_pos) in
    iter (fun pos ->
      if cell pos = new_apple_cell
      then data := !data lor mask pos
    ) snake;
    Arduboy.write_at (line new_apple_cell) (column new_apple_cell) !data;
    apple := new_apple_pos;
  ) else (
    iter (fun pos -> if pos = new_head_pos then raise Lose) snake;
    let old_apple_cell = cell old_apple_pos in
    let old_tail_pos = snake.positions.(old_tail_ind) in
    let new_head_cell = cell new_head_pos in
    let old_tail_cell = cell old_tail_pos in
    snake.tail <- new_tail_ind;
    snake.positions.(new_head_ind) <- new_head_pos;
    snake.head <- new_head_ind;
    if new_head_cell = old_tail_cell then (
      let data = ref 0 in
      iter (fun pos ->
        if cell pos = new_head_cell
        then data := !data lor mask pos
      ) snake;
      if old_apple_cell = new_head_cell
      then data := !data lor mask old_apple_pos;
      Arduboy.write_at (line new_head_cell) (column new_head_cell) !data;
    ) else (
      let new_head_data = ref 0 in
      let old_tail_data = ref 0 in
      iter (fun pos ->
        let c = cell pos in
        if c = new_head_cell then new_head_data := !new_head_data lor mask pos
        else if c = old_tail_cell then old_tail_data := !old_tail_data lor mask pos
      ) snake;
      if old_apple_cell = new_head_cell then new_head_data := !new_head_data lor mask old_apple_pos
      else if old_apple_cell = old_tail_cell then old_tail_data := !old_tail_data lor mask old_apple_pos;
      Arduboy.write_at (line new_head_cell) (column new_head_cell) !new_head_data;
      Arduboy.write_at (line old_tail_cell) (column old_tail_cell) !old_tail_data;
    );
  )

let update_direction =
  let old_left_state = ref Avr.HIGH in
  let old_right_state = ref Avr.HIGH in
  fun snake ->
    let new_left_state = Avr.digital_read Arduboy.button_left in
    let new_right_state = Avr.digital_read Arduboy.button_right in
    if new_left_state <> !old_left_state then (
      if new_left_state = Avr.HIGH then (
        old_left_state := Avr.HIGH;
      ) else (
        old_left_state := Avr.LOW;
        snake.direction <- (
          match snake.direction with
          | North -> East
          | South -> West
          | East -> South
          | West -> North
        );
      )
    ) else if new_right_state <> !old_right_state then (
      if new_right_state = Avr.HIGH then (
        old_right_state := Avr.HIGH;
      ) else (
        old_right_state := Avr.LOW;
        snake.direction <- (
          match snake.direction with
          | North -> West
          | South -> East
          | East -> North
          | West -> South
        )
      )
    )

let draw_first_apple apple =
  let apple_cell = cell apple in
  Arduboy.write_at (line apple_cell) (column apple_cell) (mask apple)

let snake_length snake =
  let len = snake.head + snake.length - snake.tail in
  if len > snake.length then len - snake.length else len
    
let play () =
  let total_len = 40 in
  let init_x    = 14 in
  let init_y    =  3 in
  let init_len  = 10 in
  let init_dir  = South in
  let snake = create total_len init_x init_y init_len init_dir in
  let apple = ref (create_apple snake) in
  draw_first_apple !apple;
  try
    while true do
      move apple snake;
      update_direction snake;
      Avr.delay (total_len - snake_length snake);
    done
  with
  | Win  -> Avr.(digital_write Arduboy.g LOW)
  | Lose -> Avr.(digital_write Arduboy.r LOW)
    
let () =
  Arduboy.init ();
  play ();
  (*
  Arduboy.init ();
  Arduboy.write_at 3 3 0xAA;
  Arduboy.write_at 3 4 0x55;
  Arduboy.write_at 3 5 0xAA;
  Arduboy.write_at 3 6 0x55;
  Arduboy.write_at 4 9 0x99;
  *)
