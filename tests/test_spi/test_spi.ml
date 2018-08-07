open Avr

type instr =
  | Data 
  | Command

let boot_sequence =
  [|
    0xD5 ; 0xF0 ; (* Set display clock divisor = 0xF0 *)
    0x8D ; 0x14; (* Enable charge Pump *)
    0xA1 ; (* Set segment re-map *)
    0xC8 ; (* Set COM Output scan direction *)
    0x81; 0xCF; (* Set contrast = 0xCF *)
    0xD9; 0xF1; (* Set precharge = 0xF1 *)
    0xAF; (* Display ON *)
    0x20; 0x00 (* Set display mode = horizontal addressing mode *)
  |]

let%node spi (instr,d) ~return:(cs,dc,data) =
  cs = LOW;
  dc = (if instr = Data then HIGH else LOW);
  data = d
                
let%node program_boot () ~return:(cs,dc,rst,data,end_boot) =
  rst = HIGH ->> LOW;
  cpt = 0 ->> (cpt + 1);
  end_boot = (cpt >= (eval (Array.length boot_sequence)));
  instr = merge end_boot Data Command;
  d     = merge end_boot (0x2 --@ end_boot) ((eval (boot_sequence.(cpt))) --@ not end_boot);
  (cs,dc,data) = spi (instr,d)
  
  
let m () =
  digital_write Arduboy.rst HIGH;
  let program = program_boot () in
  for i = 0 to 1000 do
    let (cs, dc,rst, data,end_boot) = program () in
    digital_write Arduboy.cs cs;
    digital_write Arduboy.dc dc;
    Spi.transfer data
  done
     
let () =
  Arduboy.init ();

  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  (* Oled.boot ~cs:Arduboy.cs ~dc:Arduboy.dc ~rst:Arduboy.rst; *)

  (* Oled.clear (); *)

  m ()
  (* Oled.display (); *)

