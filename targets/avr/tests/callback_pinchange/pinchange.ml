let b = PIN10
let l = PIN13

let _ =
  pin_mode b INPUT;
  pin_mode l OUTPUT;
  pin_change_callback b (fun () ->
      digital_write l (digital_read b);
    )
