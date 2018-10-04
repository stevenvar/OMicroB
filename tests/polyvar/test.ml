let () =
  trace "Hello"

type color = [
  | `GreenYellow | `Yellow | `Goldenrod | `Dandelion | `Apricot | `Peach | `Melon | `YellowOrange
  | `Orange | `BurntOrange | `Bittersweet | `RedOrange | `Mahogany | `Maroon | `BrickRed | `Red
  | `OrangeRed | `RubineRed | `WildStrawberry | `Salmon | `CarnationPink | `Magenta | `VioletRed
  | `Rhodamine | `Mulberry | `RedViolet | `Fuchsia | `Lavender | `Thistle | `Orchid | `DarkOrchid
  | `Purple | `Plum | `Violet | `RoyalPurple | `BlueViolet | `Periwinkle | `CadetBlue
  | `CornflowerBlue | `MidnightBlue | `NavyBlue | `RoyalBlue | `Blue | `Cerulean | `Cyan
  | `ProcessBlue | `SkyBlue | `Turquoise | `TealBlue | `Aquamarine | `BlueGreen | `Emerald
  | `JungleGreen | `SeaGreen | `Green | `ForestGreen | `PineGreen | `LimeGreen | `YellowGreen
  | `SpringGreen | `OliveGreen | `RawSienna | `Sepia | `Brown | `Tan
  | `RGB of int * int * int
  | `HSB of int * int * int
  | `Named of string
]

let to_string (c : color) =
  match c with
  | `Apricot | `Peach | `Salmon | `OliveGreen | `Melon | `Named "food" -> "Miam"
  | `RGB (1, 2, 3) -> "one hundred and twenty three"
  | `RGB (0, 0, 0) -> "that's black"
  | `Named "" -> "Null"
  | `SkyBlue | `SeaGreen | `PineGreen -> "Nature"
  | _ -> "Other"

let colors = [
  (`GreenYellow, "Other"); (`Yellow, "Other"); (`Goldenrod, "Other"); (`Dandelion, "Other"); (`Apricot, "Miam"); (`Peach, "Miam"); (`Melon, "Miam"); (`YellowOrange, "Other");
  (`Orange, "Other"); (`BurntOrange, "Other"); (`Bittersweet, "Other"); (`RedOrange, "Other"); (`Mahogany, "Other"); (`Maroon, "Other"); (`BrickRed, "Other"); (`Red, "Other");
  (`OrangeRed, "Other"); (`RubineRed, "Other"); (`WildStrawberry, "Other"); (`Salmon, "Miam"); (`CarnationPink, "Other"); (`Magenta, "Other"); (`VioletRed, "Other");
  (`Rhodamine, "Other"); (`Mulberry, "Other"); (`RedViolet, "Other"); (`Fuchsia, "Other"); (`Lavender, "Other"); (`Thistle, "Other"); (`Orchid, "Other"); (`DarkOrchid, "Other");
  (`Purple, "Other"); (`Plum, "Other"); (`Violet, "Other"); (`RoyalPurple, "Other"); (`BlueViolet, "Other"); (`Periwinkle, "Other"); (`CadetBlue, "Other");
  (`CornflowerBlue, "Other"); (`MidnightBlue, "Other"); (`NavyBlue, "Other"); (`RoyalBlue, "Other"); (`Blue, "Other"); (`Cerulean, "Other"); (`Cyan, "Other");
  (`ProcessBlue, "Other"); (`SkyBlue, "Nature"); (`Turquoise, "Other"); (`TealBlue, "Other"); (`Aquamarine, "Other"); (`BlueGreen, "Other"); (`Emerald, "Other");
  (`JungleGreen, "Other"); (`SeaGreen, "Nature"); (`Green, "Other"); (`ForestGreen, "Other"); (`PineGreen, "Nature"); (`LimeGreen, "Other"); (`YellowGreen, "Other");
  (`SpringGreen, "Other"); (`OliveGreen, "Miam"); (`RawSienna, "Other"); (`Sepia, "Other"); (`Brown, "Other"); (`Tan, "Other");
  (`RGB (1, 2, 3), "one hundred and twenty three"); (`RGB (0, 0, 0), "that's black"); (`RGB (2, 3, 4), "Other");
  (`HSB (5, 5, 5), "Other");
  (`Named "food", "Miam"); (`Named "hahah", "Other");
]
    
let () =
  let cnt = ref 0 in
  List.iter (fun (c, s) ->
    if to_string c <> s then failwith (s ^ " <> " ^ to_string c);
    incr cnt;
  ) colors;
  tracei !cnt;
  trace "Bye"
