open Avr

let a = Array.make 200 0

let () =
  Array.iteri (fun i _ -> write_register DDRB 0xFF) a
  (* Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI; *)
  (* boot_pins (); *)
  (* Oled.boot ~cs:PIN12 ~dc:PIN4 ~rst:PIN6; *)
  (* for i = 0 to 10 do *)
    (* Spi.transfer(0xFF); *)
    (* Oled.draw ~cs:PIN12 ~dc:PIN4 30 i; *)
    (* for i = 0 to 100 do () done; *)
    (* Oled.clear_zone ~cs:PIN12 ~dc:PIN4 30 i; *)
  (* done *)
