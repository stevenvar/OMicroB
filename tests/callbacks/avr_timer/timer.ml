let l = PIN13

let _ =
  pin_mode l OUTPUT;
  Timer0.set_period 3000;
  Timer0.set_callback (fun () ->
      digital_write l HIGH;
      delay 500;
      digital_write l LOW
    )
