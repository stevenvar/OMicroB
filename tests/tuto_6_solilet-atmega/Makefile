include ../../etc/Makefile.conf

SOURCES := solilet.ml
TARGETS := solilet.byte solilet.c solilet.elf solilet.avr solilet.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device arduino-mega -v $^ -mlopt -verbose -stack-size 800 -heap-size 450 -avrcxxopt -mmcu=atmega2560

flash: solilet.hex
	$(BIN)/omicrob -device arduino-mega -flash -sudo $< -avrdudeopts -p,atmega2560,-c,wiring,-b,115200

simul: solilet.elf
	./$< \
	'$(BIN)/omicrob_pin_simulator -device arduino-mega' \
	'$(BIN)/omicrob_circuit_simulator -device arduino-mega circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
