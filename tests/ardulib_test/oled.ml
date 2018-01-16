open Spi

module List = struct
  let rec iter f = function
      [] -> ()
    | x::xs -> (f x); iter f xs
end

let boot_program =
  [ 0xD5 ; 0xF0 ; (* Set display clock divisor = 0xF0 *)
    0x8D ; 0x14; (* Enable charge Pump *)
    0xA1 ; (* Set segment re-map *)
    0xC8 ; (* Set COM Output scan direction *)
    0x81; 0xCF; (* Set contrast = 0xCF *)
    0xD9; 0xF1; (* Set precharge = 0xF1 *)
    0xAF; (* Display ON *)
    0x20; 0x00  (* Set display mode = horizontal addressing mode *) 
  ]

(* let boot_program =
 *   [ 0x8D; 0x14; 0xAF; 0xA5 ] *)


let transfer_program prog =
  List.iter Spi.transfer prog

(* Put the display in command mode *)
let command_mode csport dcport cs dc =
  Avr.set_bit csport cs;
  Avr.clear_bit dcport dc;
  Avr.clear_bit csport cs


(* Put the display in data mode *)
let data_mode csport dcport cs dc =
  Avr.set_bit dcport dc;
  Avr.clear_bit csport cs


let send_lcd_command c =
  command_mode PORTD PORTD PD6 PD4;
  Spi.transfer c;
  data_mode PORTD PORTD PD6 PD4

let blank() =
 for i = 0 to 1023 do 
   Spi.transfer(0x88)
 done

(* Booting sequence *)
let boot () =
  let spi_clock_div2 = 0x04 in
  (* Spi.set_clock_divider spi_clock_div2; *)
  command_mode PORTD PORTD PD6 PD4;
  (* Avr.set_bit PORTB PB1; *)
  transfer_program boot_program;
  data_mode PORTD PORTD PD6 PD4;
  blank()
