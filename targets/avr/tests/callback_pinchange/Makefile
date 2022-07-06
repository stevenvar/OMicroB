include ../../../../etc/Makefile.conf

SOURCES := pinchange.ml
TARGETS := pinchange.byte pinchange.c pinchange.elf pinchange.o pinchange.hex

all: pinchange.hex pinchange.elf

pinchange.hex: pinchange.ml
	$(BIN)/omicrob -device arduino-uno -v pinchange.ml -o $@

pinchange.elf: pinchange.ml
	$(BIN)/omicrob -device arduino-uno -v pinchange.ml -o $@

flash: pinchange.hex
	$(BIN)/omicrob -device arduino-uno -flash -v $^

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
