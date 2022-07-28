include ../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.byte test.c test.elf

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: test.hex
	$(BIN)/omicrob -flash -sudo $<

simul: test.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
