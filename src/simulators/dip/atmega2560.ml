open Simul

exception Error

let pins_total = 100

let name = "ATmega 2560"

let num_of_pin pin =
  match pin with
  | (PORTG,5) -> 0
  | (PORTE,0) -> 1
  | (PORTE,1) -> 2
  | (PORTE,2) -> 3
  | (PORTE,3) -> 4
  | (PORTE,4) -> 5
  | (PORTE,5) -> 6
  | (PORTE,6) -> 7
  | (PORTE,7) -> 8
  | (PORTH,0) -> 11
  | (PORTH,1) -> 12
  | (PORTH,2) -> 13
  | (PORTH,3) -> 14
  | (PORTH,4) -> 15
  | (PORTH,5) -> 16
  | (PORTH,6) -> 17
  | (PORTB,0) -> 18
  | (PORTB,1) -> 19
  | (PORTB,2) -> 20
  | (PORTB,3) -> 21
  | (PORTB,4) -> 22
  | (PORTB,5) -> 23
  | (PORTB,6) -> 24
  | (PORTB,7) -> 25
  | (PORTH,7) -> 26
  | (PORTG,3) -> 27
  | (PORTG,4) -> 28
  | (PORTL,0) -> 34
  | (PORTL,1) -> 35
  | (PORTL,2) -> 36
  | (PORTL,3) -> 37
  | (PORTL,4) -> 38
  | (PORTL,5) -> 39
  | (PORTL,6) -> 40
  | (PORTL,7) -> 41
  | (PORTD,0) -> 42
  | (PORTD,1) -> 43
  | (PORTD,2) -> 44
  | (PORTD,3) -> 45
  | (PORTD,4) -> 46
  | (PORTD,5) -> 46
  | (PORTD,6) -> 48
  | (PORTD,7) -> 49
  | (PORTG,0) -> 50
  | (PORTG,1) -> 51
  | (PORTC,0) -> 52
  | (PORTC,1) -> 53
  | (PORTC,2) -> 54
  | (PORTC,3) -> 55
  | (PORTC,4) -> 56
  | (PORTC,5) -> 57
  | (PORTC,6) -> 58
  | (PORTC,7) -> 59
  | (PORTJ,0) -> 62
  | (PORTJ,1) -> 63
  | (PORTJ,2) -> 64
  | (PORTJ,3) -> 65
  | (PORTJ,4) -> 66
  | (PORTJ,5) -> 67
  | (PORTJ,6) -> 68
  | (PORTG,2) -> 69
  | (PORTA,7) -> 70
  | (PORTA,6) -> 71
  | (PORTA,5) -> 72
  | (PORTA,4) -> 73
  | (PORTA,3) -> 74
  | (PORTA,2) -> 75
  | (PORTA,1) -> 76
  | (PORTA,0) -> 77
  | (PORTJ,7) -> 78
  | (PORTK,7) -> 81
  | (PORTK,6) -> 82
  | (PORTK,5) -> 83
  | (PORTK,4) -> 84
  | (PORTK,3) -> 85
  | (PORTK,2) -> 86
  | (PORTK,1) -> 87
  | (PORTK,0) -> 88
  | (PORTF,7) -> 89
  | (PORTF,6) -> 90
  | (PORTF,5) -> 91
  | (PORTF,4) -> 92
  | (PORTF,3) -> 93
  | (PORTF,2) -> 94
  | (PORTF,1) -> 95
  | (PORTF,0) -> 96
  | _ -> raise Error


let name_of_num num =
  match num with
  | 0 -> "PIN4/PWM"
  | 1 -> "PIN0/RXO"
  | 2 -> "PIN1/TX0"

  | 4 -> "PIN5/PWM"
  | 5 -> "PIN2/PWM"
  | 6 -> "PIN3/PWM"

  | 9 -> "VCC"
  | 10 -> "GND"
  | 11 -> "PIN17/RX2"
  | 12 -> "PIN16/TX2"


  | 14 -> "PIN6/PWM"
  | 15 -> "PIN7/PWM"
  | 16 -> "PIN8/PWM"
  | 17 -> "PIN9/PWM"
  | 18 -> "PIN53/SS"
  | 19 -> "PIN52/SCK"
  | 20 -> "PIN51/MOSI"
  | 21 -> "PIN50/MISO"
  | 22 -> "PIN10/PWM"
  | 23 -> "PIN11/PWM"
  | 24 -> "PIN12/PWM"
  | 25 -> "PIN13/PWM"


  | 29 -> "RESET"
  | 30 -> "VCC"
  | 31 -> "GND"
  | 32 -> "XTAL2"
  | 33 -> "XTAL1"
  | 34 -> "PIN49"
  | 35 -> "PIN48"
  | 36 -> "PIN47"
  | 37 -> "PIN46/PWM"
  | 38 -> "PIN45/PWM"
  | 39 -> "PIN44/PWM"
  | 40 -> "PIN43"
  | 41 -> "PIN42"
  | 42 -> "PIN21/SCL"
  | 43 -> "PIN20/SDA"
  | 44 -> "PIN19/RX1"
  | 45 -> "PIN18/TX1"

  | 49 -> "PIN38"
  | 50 -> "PIN41"
  | 51 -> "PIN40"
  | 52 -> "PIN37"
  | 53 -> "PIN36"
  | 54 -> "PIN35"
  | 55 -> "PIN34"
  | 56 -> "PIN33"
  | 57 -> "PIN32"
  | 58 -> "PIN31"
  | 59 -> "PIN30"
  | 60 -> "VCC"
  | 61 -> "GND"
  | 62 -> "PIN15/RX3"
  | 63 -> "PIN14/TX3"

  | 69 -> "PIN39"
  | 70 -> "PIN29"
  | 71 -> "PIN28"
  | 72 -> "PIN27"
  | 73 -> "PIN26"
  | 74 -> "PIN25"
  | 75 -> "PIN24"
  | 76 -> "PIN23"
  | 77 -> "PIN22"

  | 79 -> "VCC"
  | 80 -> "GND"
  | 81 -> "A15"
  | 82 -> "A14"
  | 83 -> "A13"
  | 84 -> "A12"
  | 85 -> "A11"
  | 86 -> "A10"
  | 87 -> "A9"
  | 88 -> "A8"
  | 89 -> "A7"
  | 90 -> "A6"
  | 91 -> "A5"
  | 92 -> "A4"
  | 93 -> "A3"
  | 94 -> "A2"
  | 95 -> "A1"
  | 96  -> "A0"
  | 97 -> "ARef"
  | 98 -> "GND"
  | 99 -> "AVcc"
  | _ -> ""



let pin_of_num num =
  match num with
  | 0 -> (PORTG,5)
  | 1 -> (PORTE,0)
  | 2 -> (PORTE,1)
  | 3 -> (PORTE,2)
  | 4 -> (PORTE,3)
  | 5 -> (PORTE,4)
  | 6 -> (PORTE,5)
  | 7 -> (PORTE,6)
  | 8 -> (PORTE,7)
  | 11 -> (PORTH,0)
  | 12 -> (PORTH,1)
  | 13 -> (PORTH,2)
  | 14 -> (PORTH,3)
  | 15 -> (PORTH,4)
  | 16 -> (PORTH,5)
  | 17 -> (PORTH,6)
  | 18 -> (PORTB,0)
  | 19 -> (PORTB,1)
  | 20 -> (PORTB,2)
  | 21 -> (PORTB,3)
  | 22 -> (PORTB,4)
  | 23 -> (PORTB,5)
  | 24 -> (PORTB,6)
  | 25 -> (PORTB,7)
  | 26 -> (PORTH,7)
  | 27 -> (PORTG,3)
  | 28 -> (PORTG,4)
  | 34 -> (PORTL,0)
  | 35 -> (PORTL,1)
  | 36 -> (PORTL,2)
  | 37 -> (PORTL,3)
  | 38 -> (PORTL,4)
  | 39 -> (PORTL,5)
  | 40 -> (PORTL,6)
  | 41 -> (PORTL,7)
  | 42 -> (PORTD,0)
  | 43 -> (PORTD,1)
  | 44 -> (PORTD,2)
  | 45 -> (PORTD,3)
  | 46 -> (PORTD,4)
  | 47 -> (PORTD,5)
  | 48 -> (PORTD,6)
  | 49 -> (PORTD,7)
  | 50 -> (PORTG,0)
  | 51 -> (PORTG,1)
  | 52 -> (PORTC,0)
  | 53 -> (PORTC,1)
  | 54 -> (PORTC,2)
  | 55 -> (PORTC,3)
  | 56 -> (PORTC,4)
  | 57 -> (PORTC,5)
  | 58 -> (PORTC,6)
  | 59 -> (PORTC,7)
  | 62 -> (PORTJ,0)
  | 63 -> (PORTJ,1)
  | 64 -> (PORTJ,2)
  | 65 -> (PORTJ,3)
  | 66 -> (PORTJ,4)
  | 67 -> (PORTJ,5)
  | 68 -> (PORTJ,6)
  | 69 -> (PORTG,2)
  | 70 -> (PORTA,7)
  | 71 -> (PORTA,6)
  | 72 -> (PORTA,5)
  | 73 -> (PORTA,4)
  | 74 -> (PORTA,3)
  | 75 -> (PORTA,2)
  | 76 -> (PORTA,1)
  | 77 -> (PORTA,0)
  | 78 -> (PORTJ,7)
  | 81 -> (PORTK,7)
  | 82 -> (PORTK,6)
  | 83 -> (PORTK,5)
  | 84 -> (PORTK,4)
  | 85 -> (PORTK,3)
  | 86 -> (PORTK,2)
  | 87 -> (PORTK,1)
  | 88 -> (PORTK,0)
  | 89 -> (PORTF,7)
  | 90 -> (PORTF,6)
  | 91 -> (PORTF,5)
  | 92 -> (PORTF,4)
  | 93 -> (PORTF,3)
  | 94 -> (PORTF,2)
  | 95 -> (PORTF,1)
  | 96  -> (PORTF,0)
  | _ -> raise Error

let pin_of_an = function
  | 15 -> (PORTK,7)
  | 14 -> (PORTK,6)
  | 13 -> (PORTK,5)
  | 12 -> (PORTK,4)
  | 11 -> (PORTK,3)
  | 10 -> (PORTK,2)
  | 9 -> (PORTK,1)
  | 8 -> (PORTK,0)
  | 7 -> (PORTF,7)
  | 6 -> (PORTF,6)
  | 5 -> (PORTF,5)
  | 4 -> (PORTF,4)
  | 3 -> (PORTF,3)
  | 2 -> (PORTF,2)
  | 1 -> (PORTF,1)
  | 0  -> (PORTF,0)
  | _ -> raise Error

let char_of_port p =
  match p with
  | PORTA -> 'A'
  | PORTB -> 'B'
  | PORTC -> 'C'
  | PORTD -> 'D'
  | PORTE -> 'E'
  | PORTF -> 'F'
  | PORTG -> 'G'
  | PORTH -> 'H'
  | PORTI -> 'I'
  | PORTJ -> 'J'
  | PORTK -> 'K'
  | PORTL -> 'L'
  | _ -> '?'

let init_state_of_num =
  function
  | _ -> false
