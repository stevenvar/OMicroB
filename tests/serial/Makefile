include ../../etc/Makefile.conf

SOURCES := serial.ml
TARGETS := serial.byte serial.c serial.elf serial.avr serial.hex
ATTY := /dev/tty.usbmodem*

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^

flash: serial.hex
	$(BIN)/omicrob -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
