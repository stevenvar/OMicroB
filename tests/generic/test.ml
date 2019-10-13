(** No need to open something specific ! *)

let _ =
  let r = PIN8 in
  pin_mode r OUTPUT;
  while true do
    digital_write r HIGH;
    delay 500;
    digital_write r LOW;
    delay 500
  done
