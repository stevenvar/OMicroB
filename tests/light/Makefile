include ../../etc/Makefile.conf

DEVICE ?= arduino-uno

SOURCES := light.ml
TARGETS := light.byte light.c light.elf light.avr light.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -gc MAC -arch 16

flash: light.hex
	$(BIN)/omicrob -device $(DEVICE) -v -flash -sudo $<


simul: light.elf
	./$< \
	'$(BIN)/omicrob_pin_simulator -device=$(DEVICE)' \
	'$(BIN)/omicrob_circuit_simulator -device=$(DEVICE) circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
