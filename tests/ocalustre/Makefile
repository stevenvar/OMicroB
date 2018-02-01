include ../../etc/Makefile.conf

SOURCES :=  ardulib.ml
TARGETS := ardulib.byte ardulib.c ardulib.elf ardulib.avr ardulib.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 64 -heap-size 300

flash: ardulib.hex
	$(BIN)/omicrob -flash -sudo $<

simul: ardulib.elf
	./$< '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
