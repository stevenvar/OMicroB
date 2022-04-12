include ../../etc/Makefile.conf

SOURCES := light.ml
TARGETS := light.byte light.c light.elf light.avr light.hex
ATTY := /dev/ttyACM0

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device arduino-uno -v $^ -gc MAC -arch 16

flash: light.hex
	$(BIN)/omicrob -device arduino-uno -v -flash -sudo $<


simul: light.elf
	./$< '../../bin/omicrob_pin_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
