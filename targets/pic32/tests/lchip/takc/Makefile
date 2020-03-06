include ../../../../../etc/Makefile.conf

SOURCES := takc.ml
TARGETS := takc.byte takc.c takc.elf takc.avr takc.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 800 -heap-size 450

flash: takc.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: takc.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
