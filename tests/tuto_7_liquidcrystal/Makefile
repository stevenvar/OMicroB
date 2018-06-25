include ../../etc/Makefile.conf

SOURCES := lcdexample.ml
TARGETS := lcdexample.byte lcdexample.c lcdexample.elf lcdexample.avr lcdexample.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -heap-size 256

flash: lcdexample.hex
	$(BIN)/omicrob -flash -sudo $<

simul: lcdexample.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
