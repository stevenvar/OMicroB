open Pic32

let _ =
  _init ();
  schedule_task ();
  pin_mode PINA0 OUTPUT;
  let brightness = ref 0
  and fade_amount = 5 in
  while true do
    analog_write PINA0 !brightness;
    brightness :=
    (if !brightness <= 0 || !brightness >= 1024 then !brightness - fade_amount else !brightness + fade_amount);
    delay 30;
  done
