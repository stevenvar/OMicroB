include ../../etc/Makefile.conf

SOURCES := serial.ml
TARGETS := serial.byte serial.c serial.elf serial.avr serial.hex
ATTY := /dev/ttyACM0

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -device arduino-mega -gc MAC -stack-size 300 -heap-size 800

flash: serial.hex
	sudo ./reset.py $(ATTY)
	$(BIN)/omicrob -v -device arduino-mega -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
