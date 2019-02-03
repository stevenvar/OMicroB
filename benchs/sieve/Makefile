include ../../etc/Makefile.conf

SOURCES := sieve.ml
TARGETS := sieve.byte sieve.c sieve.elf sieve.avr sieve.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -heap-size 2000 -stack-size 2000

flash: sieve.hex
	$(BIN)/omicrob -flash -sudo $<

simul: sieve.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
