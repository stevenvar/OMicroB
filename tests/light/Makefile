include ../../etc/Makefile.conf

SOURCES := light.ml
TARGETS := light.byte light.c light.elf light.avr light.hex
ATTY := /dev/tty.usbmodem*

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -gc MAC -arch 16 -no-flash-heap -stack-size 300 -heap-size 800
	# $(BIN)/omicrob -v $^ -gc SC -arch 16 -no-flash-heap -no-flash-globals -stack-size 300 -heap-size 800

flash: light.hex
	sudo ./reset.py $(ATTY)
	$(BIN)/omicrob -v -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
