open Avr

let light_switch () l = let trigger = 200 in let on = l > trigger in (on,l)


let () =
let module IO =
    struct
      let light_switch_init () = 
        Avr.adc_init (); 
        Avr.Serial.init ();
        Avr.pin_mode PIN13 OUTPUT

      let light_switch_step_in () = 
        Avr.analog_read PINA0

      let light_switch_step_out (on) = 
        if on then Avr.digital_write PIN13 HIGH
        else Avr.digital_write PIN13 LOW


    end in
    let open IO in
      light_switch_init ();
      (let main = light_switch () in
       for i = 0 to 100 do
         let _delay_ms = millis () in
         let l = light_switch_step_in () in
         let (on,l) = main l in 
         light_switch_step_out (on) ;
         (let _delay_ms = (millis ()) - _delay_ms in delay (200 - _delay_ms)) done);
  Avr.Serial.write_int (Gc.collections ())
