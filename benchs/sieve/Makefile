include ../../etc/Makefile.conf

SOURCES := sieve.ml
TARGETS := sieve.byte sieve.c sieve.elf sieve.avr sieve.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: sieve.hex
	$(BIN)/omicrob -flash -sudo $<

simul: sieve.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
