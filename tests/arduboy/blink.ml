module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end

let blink pin small_time long_time =
  pin_mode pin OUTPUT;
  digital_write pin true;
  for i = 1 to 100 do
    delay long_time;
    for _j = 1 to i do
      digital_write pin false;
      delay small_time;
      digital_write pin true;
      delay small_time;
    done;
  done

let () =
  Arduboy.init ();
  Arduboy.print "Hello from OCaml!";
  Arduboy.display ();
  blink PIN17 100 1000
