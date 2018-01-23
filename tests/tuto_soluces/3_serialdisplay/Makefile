include ../../../etc/Makefile.conf

SOURCES := buffer.c spi.ml oled.ml display.ml
TARGETS := display.byte display.c display.elf display.avr display.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 32 -heap-size 100

flash: display.hex
	$(BIN)/omicrob -flash -sudo $<

simul: display.elf
	./$< '../../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
