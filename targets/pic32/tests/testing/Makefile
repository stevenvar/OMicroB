include ../../../../etc/Makefile.conf

SOURCES := testing.ml
TARGETS := testing.byte testing.c testing.elf testing.hex
ATTY := /dev/tty.usbmodem1411

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device lchip -mlopt -verbose -stack-size 200 -heap-size 200

flash: testing.hex
	$(BIN)/omicrob -v -flash -device lchip $^

simul: testing.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
