include ../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.byte test.c test.elf test.hex

DEVICE ?= arduino-uno

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 200 -heap-size 200

clean:
	@rm -f *.cmo *.cmi

flash: test.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: test.elf
	./$< \
	'$(BIN)/omicrob_pin_simulator -device=$(DEVICE)' \
	'$(BIN)/omicrob_circuit_simulator -device=$(DEVICE) circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -f $(TARGETS)

.PHONY: all flash clean
