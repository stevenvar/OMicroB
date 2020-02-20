include ../../../../etc/Makefile.conf

SOURCES := buzzer.ml
TARGETS := buzzer.byte buzzer.c buzzer.elf buzzer.avr buzzer.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device arduboy -v $^ -mlopt -verbose -stack-size 32 -heap-size 32

flash: buzzer.hex
	$(BIN)/omicrob -device arduboy -flash -sudo $<

simul: buzzer.elf
	./$< '../../../bin/omicrob_pin_simulator' '../../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
