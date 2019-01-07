include ../../etc/Makefile.conf

SOURCES := lcdexample.ml
TARGETS := lcdexample.byte lcdexample.c lcdexample.elf lcdexample.avr lcdexample.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device arduino-uno -heap-size 256

flash: lcdexample.hex
	$(BIN)/omicrob -device arduino-uno -flash -sudo $<

simul: lcdexample.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
