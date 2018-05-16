include ../../../etc/Makefile.conf

SOURCES := led.ml
TARGETS := led.byte led.c led.elf led.avr led.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob  -v $^ -mlopt -verbose -stack-size 64 -heap-size 300 -arch 32


flash: led.hex
	$(BIN)/omicrob -flash -sudo $<

simul: led.elf
	./$< '../../../bin/omicrob_pin_simulator' '../../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
