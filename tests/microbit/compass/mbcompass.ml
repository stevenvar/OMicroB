open Screen

let arrow_of_heading h =
  if h >= 338 || h < 23 then [(2, 0);(2, 1)] (* N *)
  else if h >= 23 && h < 68 then [(0,0);(1,1)] (* NE *)
  else if h >= 68 && h < 113 then [(0,2);(1,2)] (* E *)
  else if h >= 113 && h < 158 then [(0,4);(1,3)] (* SE *)
  else if h >= 158 && h < 203 then [(2,4);(2,3)] (* S *)
  else if h >= 203 && h < 248 then [(4,4);(3,3)] (* SO *)
  else if h >= 248 && h < 293 then [(4,2);(3,2)]  (* O *)
  else [(4,0);(3,1)] (* NO *)

let _ =
  while true do
    clear_screen ();
    set_pixel 2 2 HIGH;
    List.iter (fun (x, y) -> set_pixel x y HIGH)(arrow_of_heading (Compass.heading ()));
    delay 10;
  done
