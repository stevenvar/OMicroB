include ../../etc/Makefile.conf

SOURCES := integr.ml
TARGETS := integr.byte integr.c integr.elf integr.avr integr.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: integr.hex
	$(BIN)/omicrob -flash -sudo $<

simul: integr.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
