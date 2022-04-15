include ../../etc/Makefile.conf

DEVICE ?= arduino-uno

SOURCES := test.ml
TARGETS := test.byte test.c test.elf test.avr test.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -arch 32 -v $^ -mlopt -verbose

flash: test.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -sudo $<

simul: test.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
