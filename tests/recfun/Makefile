include ../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.byte test.c test.elf test.avr test.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -arch 64 -v $^ -mlopt -verbose -stack-size 2048 -trace 2

flash: test.hex
	$(BIN)/omicrob -flash -sudo $<

simul: test.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
