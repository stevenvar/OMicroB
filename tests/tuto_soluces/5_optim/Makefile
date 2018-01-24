include ../../../etc/Makefile.conf

SOURCES := buffer.c spi.ml oled.ml arduboy.ml snake.ml
TARGETS := snake.byte snake.c snake.elf snake.avr snake.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 35 -heap-size 300

flash: snake.hex
	$(BIN)/omicrob -flash -sudo $<

simul: snake.elf
	./$< '../../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
