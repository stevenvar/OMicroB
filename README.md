# OCaml on Microcontrollers' Boards

## Requirements

- OPAM + OCaml (>= 4.03 )
- obytelib (on OPAM)
- ocamlclean (on OPAM)
- ocamlbuild (on OPAM)
- gcc (for simulation)

For flashing (optional but fun) you'll need the avr-gcc tools :

On MacOS (with HomeBrew) :

```
brew tap osx-cross/avr
brew install avr-libc
brew install avrdude --with-usb
```

On Ubuntu/Debian Linux : 

```
sudo apt-get install gcc-avr binutils-avr avr-libc
sudo apt-get install avrdude
```