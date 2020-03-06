include ../../../etc/Makefile.conf

SOURCES := sieve.ml
TARGETS := sieve.byte sieve.c sieve.elf sieve.avr sieve.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 800 -heap-size 2500

flash: sieve.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: sieve.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
