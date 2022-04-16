include ../../etc/Makefile.conf

DEVICE ?= arduboy

SOURCES := solilet.ml
TARGETS := solilet.byte solilet.c solilet.elf solilet.avr solilet.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 800 -heap-size 450

flash: solilet.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: solilet.elf
	./$< '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
