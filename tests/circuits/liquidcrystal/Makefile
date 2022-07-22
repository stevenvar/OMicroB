include ../../../etc/Makefile.conf

DEVICE ?= arduino-uno

SOURCES := lcdexample.ml
TARGETS := lcdexample.byte lcdexample.c lcdexample.elf lcdexample.avr lcdexample.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device $(DEVICE) -circuitppx -heap-size 256

flash: lcdexample.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: lcdexample.elf
	./$< '$(BIN)/omicrob_pin_simulator -device=$(DEVICE)' \
		 '$(BIN)/omicrob_lcd_16x2_simulator -device=$(DEVICE) -e=PIN12 -rs=PIN11 -rw=PIN0 -d4=PIN2 -d5=PIN3 -d6=PIN4 -d7=PIN5 16x2'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
