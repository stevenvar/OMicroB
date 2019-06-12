include ../../etc/Makefile.conf

SOURCES := lcdexample.ml
TARGETS := lcdexample.byte lcdexample.c lcdexample.elf lcdexample.avr lcdexample.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -no-shortcut-initialization -heap-size 256

flash: lcdexample.hex
	$(BIN)/omicrob -flash -sudo $<

simul: lcdexample.elf
	./$< ../../bin/omicrob_pin_simulator '../../bin/omicrob_lcd_16x2_simulator e=PIN12 rs=PIN11 rw=PIN10 d4=PIN9 d5=PIN8 d6=PIN7 d7=PIN6 16x2'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
