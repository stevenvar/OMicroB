include ../../../../etc/Makefile.conf

SOURCES := led.ml
TARGETS := led.byte led.c led.elf led.avr led.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device arduino-mega -mlopt -verbose -stack-size 32 -heap-size 32 -arch 64 -avrcxxopts -Os

flash: led.hex
	$(BIN)/omicrob -device arduino-mega -avrdudeopts -c,wiring,-b,115200 -flash -sudo $<

simul: led.elf
	./$< '../../bin/omicrob_pin_simulator' '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
