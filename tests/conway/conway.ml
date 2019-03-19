type case = Dead | Alive (* You spin me round *)
type grid = case array array

module Display = MicroBit.Screen (* microbit screen (5*5 led grid) *)
let n = 5 and m = 5

let update_grid g =
  (* Count neighbours*)
  let neighbours = Array.make_matrix n m 0 in
  for y = 0 to n - 1 do
    for x = 0 to m - 1 do
      for i = -1 to 1 do
        for j = -1 to 1 do
          let i = ((y+i)+n) mod n
          and j = ((x+j)+m) mod m in
          if (i != y || j != x) && g.(i).(j) = Alive
          then neighbours.(y).(x) <- neighbours.(y).(x) + 1
        done
      done
    done
  done;

  (* Update grid *)
  for i = 0 to n - 1 do
    for j = 0 to m - 1 do
      if g.(i).(j) = Alive && (neighbours.(i).(j) < 2 || neighbours.(i).(j) > 3)
      then g.(i).(j) <- Dead
      else if g.(i).(j) = Dead && neighbours.(i).(j) = 3 then g.(i).(j) <- Alive
    done
  done

let display_grid g =
  for i = 0 to n - 1 do
    for j = 0 to m - 1 do
      match g.(i).(j) with
      | Dead -> Display.set_pixel i j LOW
      | Alive -> Display.set_pixel i j HIGH
    done
  done

let _ =
  (* Initial shape *)
  let g = Array.make_matrix n m Dead in

  (* Glider *)
  g.(0).(1) <- Alive;
  g.(1).(2) <- Alive;
  g.(2).(0) <- Alive; g.(2).(1) <- Alive; g.(2).(2) <- Alive;

  (* Main loop *)
  while true do
    display_grid g;
    update_grid g;
    delay 500
  done
