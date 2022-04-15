include ../../etc/Makefile.conf

DEVICE ?= arduino-mega

SOURCES := queens.ml
TARGETS := queens.byte queens.c queens.elf queens.avr queens.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -no-flash-heap -no-flash-globals -arch 32 -trace 1 -v $^ -mlopt -verbose -stack-size 2000 -heap-size 4000

flash: queens.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: queens.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
