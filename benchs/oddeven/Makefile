include ../../etc/Makefile.conf

SOURCES := oddeven.ml
TARGETS := oddeven.byte oddeven.c oddeven.elf oddeven.avr oddeven.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: oddeven.hex
	$(BIN)/omicrob -flash -sudo $<

simul: oddeven.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
