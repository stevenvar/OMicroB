include ../../etc/Makefile.conf

DEVICE ?= arduino-uno

SOURCES := serial.ml
TARGETS := serial.byte serial.c serial.elf serial.avr serial.hex
ATTY := /dev/tty.usbmodem*

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) -v $^ -gc MAC -arch 16 -no-flash-heap

flash: serial.hex
	$(BIN)/omicrob -device $(DEVICE) -v -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
