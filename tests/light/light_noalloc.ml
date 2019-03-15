open Avr
type ('a, 'b) light_switch_state =
  {
  mutable light_switch_out_on: 'a;
  mutable light_switch_out_lout: 'b;
  }

let light_switch_init l =
  let trigger = 200 in
  let on = l > trigger in
  let lout = l in { light_switch_out_on = on; light_switch_out_lout = lout }
let light_switch_step state l =
  let trigger = 200 in
  let on = l > trigger in
  let lout = l in
  state.light_switch_out_lout <- lout; state.light_switch_out_on <- on; ()

module IO =
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

    end



let _ = 
  IO.light_switch_init ();
  let l = IO.light_switch_step_in () in 
  let st = light_switch_init l in 
  IO.light_switch_step_out st.light_switch_out_on;
  for i = 0 to 10000 do
    let l = IO.light_switch_step_in () in 
    light_switch_step st l;
    IO.light_switch_step_out st.light_switch_out_on;
  done;
  Avr.Serial.write_int (Gc.collections ())
  

