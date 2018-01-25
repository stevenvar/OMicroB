include ../../etc/Makefile.conf

SOURCES := solilet.ml
TARGETS := solilet.byte solilet.c solilet.elf solilet.avr solilet.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 800 -heap-size 450 -avrcxxopt -mmcu=atmega2560

flash: solilet.hex
	$(BIN)/omicrob -flash -sudo $< -avrdudeopts -p,atmega2560,-c,wiring,-b,115200

simul: solilet.elf
	./$< '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
