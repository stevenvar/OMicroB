include ../../etc/Makefile.conf

SOURCES := point.ml
TARGETS := point.byte point.c point.elf point.avr point.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -no-shortcut-initialization -mlopt -unsafe -heap-size 5005 -stack-size 1000 -trace 3

flash: point.hex
	$(BIN)/omicrob -flash -sudo $<

simul: point.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
