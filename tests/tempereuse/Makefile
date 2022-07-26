include ../../etc/Makefile.conf

SOURCES := thermo_io.ml temp.ml
TARGETS := temp.byte temp.c temp.elf temp.avr temp.hex

DEVICE ?= arduino-mega

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	../../bin/omicrob -device $(DEVICE) -circuitppx -mlopts -ppx,"ocalustre -m thermo" -v $^ -stack-size 70 -heap-size 200 -arch 16 -gc SC

simul: temp.elf
	./$< \
	'$(BIN)/omicrob_pin_simulator -device=$(DEVICE)' \
	'$(BIN)/omicrob_circuit_simulator -device=$(DEVICE) circuit.txt'

flash: temp.hex
	../../bin/omicrob -device $(DEVICE) -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
