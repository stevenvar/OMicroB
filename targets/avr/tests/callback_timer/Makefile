include ../../../../etc/Makefile.conf

SOURCES := timer.ml
TARGETS := timer.byte timer.c timer.elf timer.o timer.hex

DEVICE ?= arduino-uno

all: timer.hex timer.elf

timer.hex: timer.ml
	$(BIN)/omicrob -device $(DEVICE) -v timer.ml -o $@

timer.elf: timer.ml
	$(BIN)/omicrob -device $(DEVICE) -v timer.ml -o $@

flash: timer.hex
	$(BIN)/omicrob -device $(DEVICE) -flash -v $^

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
