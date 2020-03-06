include ../../../../../etc/Makefile.conf

SOURCES := solilet.ml
TARGETS := solilet.byte solilet.c solilet.elf solilet.avr solilet.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 800 -heap-size 450

flash: solilet.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: solilet.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
