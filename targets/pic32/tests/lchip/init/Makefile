include ../../../../../etc/Makefile.conf

SOURCES := init.ml
TARGETS := init.byte init.c init.elf init.avr init.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 200 -heap-size 200

flash: init.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: init.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
