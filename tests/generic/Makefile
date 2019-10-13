include ../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.byte test.c test.elf test.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 200 -heap-size 200 -o test.elf

clean:
	@rm -f *.cmo *.cmi

flash: test.hex
	$(BIN)/omicrob -device arduino-uno -flash -sudo $<

simul: test.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -f $(TARGETS)

.PHONY: all flash clean
