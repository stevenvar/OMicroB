include ../../etc/Makefile.conf

DEVICE ?= arduboy

SOURCES := buttons.ml
TARGETS := buttons.byte buttons.c buttons.elf buttons.avr buttons.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 32 -heap-size 32

flash: buttons.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: buttons.elf
	./$< '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
