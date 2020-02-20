let _ =
  pin_mode PIN13 OUTPUT;
  pin_mode PIN5 OUTPUT;
  while true do
    digital_write PIN13 HIGH;
    digital_write PIN5 LOW;
    digital_write PIN13 LOW;
    digital_write PIN5 HIGH;
  done
