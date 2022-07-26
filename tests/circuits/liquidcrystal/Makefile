include ../../../etc/Makefile.conf

DEVICE ?= arduino-uno

SOURCES := lcdexample.ml
TARGETS := lcdexample.byte lcdexample.c lcdexample.elf lcdexample.avr lcdexample.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device $(DEVICE) -circuitppx -heap-size 256

flash: lcdexample.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: lcdexample.elf
	./$< '$(BIN)/omicrob_pin_simulator -device=$(DEVICE)' \
	'$(BIN)/omicrob_circuit_simulator -device=$(DEVICE) circuit.txt' \

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
