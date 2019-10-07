open Simul

exception Error

type pin = port * int

let pins_total = 44

let name = "Atmega32u4"

let num_of_pin pin =
  match pin with
  | (PORTE, 6) -> 0
  | (PORTB, 0) -> 7
  | (PORTB, 1) -> 8
  | (PORTB, 2) -> 9
  | (PORTB, 3) -> 10
  | (PORTB, 7) -> 11
  | (PORTD, 0) -> 17
  | (PORTD, 1) -> 18
  | (PORTD, 2) -> 19
  | (PORTD, 3) -> 20
  | (PORTD, 5) -> 21
  | (PORTD, 4) -> 24
  | (PORTD, 6) -> 25
  | (PORTD, 7) -> 26
  | (PORTB, 4) -> 27
  | (PORTB, 5) -> 28
  | (PORTB, 6) -> 29
  | (PORTC, 6) -> 30
  | (PORTC, 7) -> 31
  | (PORTE, 2) -> 32
  | (PORTF, 7) -> 35
  | (PORTF, 6) -> 36
  | (PORTF, 5) -> 37
  | (PORTF, 4) -> 38
  | (PORTF, 1) -> 39
  | (PORTF, 0) -> 40
  | _ -> raise Error
;;

(* returns if is input *)
let init_state_of_num i =
  match i with
  | 19 -> true
  | 35 | 36 | 37 | 38 | 39 | 40 -> true
  | 14 | 34 -> true
  | _ -> false


let pin_of_num num =
  match num with
    0 -> (PORTE,6)
  | 7 -> (PORTB,0)
  | 8 -> (PORTB,1)
  | 9 -> (PORTB,2)
  | 10 -> (PORTB,3)
  | 11 -> (PORTB, 7)
  | 17 -> (PORTD, 0)
  | 18 -> (PORTD, 1)
  | 19 -> (PORTD, 2)
  | 20 -> (PORTD, 3)
  | 21 -> (PORTD, 5)
  | 24 -> (PORTD, 4)
  | 25 -> (PORTD, 6)
  | 26 -> (PORTD, 7)
  | 27 -> (PORTB, 4)
  | 28 -> (PORTB, 5)
  | 29 -> (PORTB, 6)
  | 30 -> (PORTC, 6)
  | 31 -> (PORTC, 7)
  | 32 -> (PORTE, 2)
  | 35 -> (PORTF, 7)
  | 36 -> (PORTF, 6)
  | 37 -> (PORTF, 5)
  | 38 -> (PORTF, 4)
  | 39 -> (PORTF, 1)
  | 40 -> (PORTF, 0)
  | _ -> raise Error
;;

let name_of_num num =
  match num with
    0 -> "PIN7"
  | 1 -> "UVcc"
  | 2 -> "RD-"
  | 3 -> "RD+"
  | 4 -> "UGND"
  | 5 -> "UCAP"
  | 6 -> "VUSB"
  | 7 -> "RXLED"
  | 8 -> "SCK"
  | 9 -> "MOSI"
  | 10 -> "MISO"
  | 11 -> "PIN11"
  | 12 -> "RESET"
  | 13 -> "VCC"
  | 14 -> "GND"
  | 15 -> "XTAL2"
  | 16 -> "XTAL1"
  | 17 -> "PIN3"
  | 18 -> "PIN2"
  | 19 -> "PIN0/RX"
  | 20 -> "PIN1/TX"
  | 21 -> "TXLED"
  | 22 -> "GND"
  | 23 -> "AVCC"
  | 24 -> "PIN4"
  | 25 -> "PIN12"
  | 26 -> "PIN6"
  | 27 -> "PIN8"
  | 28 -> "PIN9"
  | 29 -> "PIN10"
  | 30 -> "PIN5"
  | 31 -> "PIN13"
  | 32 -> "HWB"
  | 33 -> "VCC"
  | 34 -> "GND"
  | 35 -> "AN0"
  | 36 -> "AN1"
  | 37 -> "AN2"
  | 38 -> "AN3"
  | 39 -> "AN4"
  | 40 -> "AN5"
  | 41 -> "AREF"
  | 42 -> "AGND"
  | 43 -> "AVCC"
  | _ -> raise Error


let char_of_port p =
  match p with
  | PORTB -> 'B'
  | PORTC -> 'C'
  | PORTD -> 'D'
  | PORTE -> 'E'
  | PORTF -> 'F'
  | _ -> '?'



let pin_of_an an = match an with
  | 0 -> (PORTF, 7)
  | 1 -> (PORTF, 6)
  | 2 -> (PORTF, 5)
  | 3 -> (PORTF, 4)
  | 4 -> (PORTF, 1)
  | 5 -> (PORTF, 0)
  | _ -> raise Error
