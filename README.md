# OCaml on Microcontrollers' Boards

OMicroB is an OCaml virtual machine dedicated at running OCaml programs on devices with very limited resources such as AVR Atmega32u4 microcontrollers (2.5 ko of RAM).

This tools, steming from the works of OCaPIC (https://github.com/bvaugon/ocapic) is seen as a generic virtual machine approach, which can be ported on various architectures.

OMicroB performs multiple static analysis passes in order to reduce the generated final executable.

## Published version

An article describing our generic virtual machine approach has been published on ERTS 2018 :

[A Generic Virtual Machine Approach for Programming Microcontrollers: the OMicroB Project (S. Varoumas, B. Vaugon, E. Chailloux)](http://hal.upmc.fr/hal-01705825/document)


## Requirements

- OPAM + OCaml (>= 4.03)
- obytelib (on OPAM)
- ocamlclean (on OPAM)
- ocamlbuild (on OPAM)
- gcc (for simulation)
- avr-gcc and avrdude (for flashing to an AVR microcontroller)

## Installing

```console
./configure && make && make install
```