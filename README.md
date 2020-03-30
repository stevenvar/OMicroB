# OCaml on Microcontroller Boards

![OCaml](https://img.shields.io/badge/OCaml-4.07-orange?logo=OCaml&logoColor=white)


OMicroB is an OCaml virtual machine dedicated at running OCaml programs on devices with very limited resources such as AVR Atmega32u4 microcontrollers (2.5 ko of RAM).

This tools, steming from the works of OCaPIC (https://github.com/bvaugon/ocapic) consists of a generic virtual machine, which can be ported on various architectures.

OMicroB performs multiple static analysis passes in order to reduce the generated final executable.

## Published version

An article describing our generic virtual machine approach has been published in ERTS 2018 :

[A Generic Virtual Machine Approach for Programming Microcontrollers: the OMicroB Project (S. Varoumas, B. Vaugon, E. Chailloux)](http://hal.upmc.fr/hal-01705825/document)


## Requirements

- OPAM2 + OCaml (>= 4.07)
  (OCaml versions prior to 4.07 are not supported at the moment because of changes in the bytecode instructions and in the structure of the standard library of the language since v. 4.07)
- obytelib (on OPAM)
- ocamlclean (on OPAM)
- ocamlbuild (on OPAM)
- gcc (for simulation)
- avr-gcc, avr-libc (for AVR microcontrollers)
- avrdude (for flashing to an AVR)
- xc32 (for PIC32 microcontrollers)
- pic32prog (for fashing to a PIC32)

## Installing

OMicroB currently supports AVR and PIC32 microcontrollers. 
The installation process requires to specify which type of microcontrollers OMicroB should be compiled for.

For this, you should edit the *configure* file and comment/uncomment the calls to `target_avr`, `target_pic32`, ... depending on the architectures you would like to enable. The configuration script will then check that you do have the right dependencies installed for the architectures you selected.

```console
./configure && make && make install
```


## Compiling an OCaml program

In order to compile an OCaml file, run

```
omicrob <file.ml> -device $DEVICE
```

that will generate a ```<file.hex>``` executable. 
The ```omicrob -list-devices``` command lists possible values for ```$DEVICE```. 
Note that available devices vary depending on whether OMicroB is compiled for AVR or PIC32. 

(The ```omicrob -help``` command will display the various available options, such as setting the stack size, the garbage collector algorithm, etc)

## Flashing on a microcontroller

```console
omicrob -flash <file.hex> -device $DEVICE
```

## Simulator

OMicroB comes with a circuit simulator, for example running

```console
make simul
```
in the ```tests/snake-mustard``` folder will simulate an [Arduboy]([https://arduboy.com) device on your computer, running the Snake game described in this folder.

