include ../../etc/Makefile.conf

DEVICE ?= arduboy

SOURCES := led.ml
TARGETS := led.byte led.c led.elf led.avr led.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 200 -heap-size 200

flash: led.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: led.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
