let () =
  pin_mode PIN13 OUTPUT;
  for i = 1 to 100 do
    for _j = 1 to i do
      digital_write PIN13 true;
      delay 100;
      digital_write PIN13 false;
      delay 100;
    done;
    delay 1000;
  done
