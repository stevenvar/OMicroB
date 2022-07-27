include ../../etc/Makefile.conf

DEVICE ?= arduboy

SOURCES := buffer.c spi.ml oled.ml arduboy.ml snake.ml
TARGETS := snake.byte snake.c snake.elf snake.avr snake.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 64 -heap-size 300

flash: snake.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: snake.elf
	./$< '../../bin/omicrob_circuit_simulator -device $(DEVICE) circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
