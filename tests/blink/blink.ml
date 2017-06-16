let blink pin small_time long_time =
  pin_mode pin OUTPUT;
  for i = 1 to 100 do
    for _j = 1 to i do
      digital_write pin true;
      delay small_time;
      digital_write pin false;
      delay small_time;
    done;
    delay long_time;
  done

let () =
  blink PIN13 100 1000
