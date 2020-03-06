include ../../../../../etc/Makefile.conf

SOURCES := queens.ml
TARGETS := queens.byte queens.c queens.elf queens.avr queens.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 800 -heap-size 2500

flash: queens.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: queens.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
