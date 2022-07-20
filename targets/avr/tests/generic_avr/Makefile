include ../../../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.elf test.hex

DEVICE ?= arduino-uno

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device $(DEVICE) -mlopt -verbose -stack-size 200 -heap-size 200

flash: test.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: test.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
