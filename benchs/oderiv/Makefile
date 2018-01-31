include ../../etc/Makefile.conf

SOURCES := oderiv.ml
TARGETS := oderiv.byte oderiv.c oderiv.elf oderiv.avr oderiv.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: oderiv.hex
	$(BIN)/omicrob -flash -sudo $<

simul: oderiv.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
