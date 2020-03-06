include ../../../../../etc/Makefile.conf

SOURCES := cwint.ml
TARGETS := cwint.byte cwint.c cwint.elf cwint.avr cwint.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 200 -heap-size 200

flash: cwint.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: cwint.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
