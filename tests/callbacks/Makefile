include ../../etc/Makefile.conf

SOURCES := callbacks.ml
TARGETS := callbacks.byte callbacks.c callbacks.elf callbacks.o callbacklib.o #callbacks.avr callbacks.hex
ATTY := /dev/tty.usbmodem*

all: callbacks.elf

callbacklib.o: callbacklib.c
	ocamlc -o callbacklib.o callbacklib.c -ccopt -D__OCAML__

callbacks.elf: callbacks.ml callbacklib.c callbacklib.o
	$(BIN)/omicrob -v callbacks.ml -mlopt callbacklib.o -bc2copts -i,callbacklib.c -o $@

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
