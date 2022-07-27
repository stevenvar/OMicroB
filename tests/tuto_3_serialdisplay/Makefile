include ../../etc/Makefile.conf

DEVICE ?= arduboy

SOURCES := buffer.c spi.ml oled.ml display.ml
TARGETS := display.byte display.c display.elf display.avr display.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -mlopt -verbose -stack-size 32 -heap-size 300

flash: display.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: display.elf
	./$< \
	'$(BIN)/omicrob_pin_simulator -device $(DEVICE)'  \
	'$(BIN)/omicrob_circuit_simulator -device $(DEVICE) circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
