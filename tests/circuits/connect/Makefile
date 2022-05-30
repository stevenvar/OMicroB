include ../../../etc/Makefile.conf

DEVICE ?= arduino-uno

all: connect.hex

connect.hex: connect.ml
	$(BIN)/omicrob -v -device=$(DEVICE) -circuitppx $^ -o $@

flash: connect.hex
	$(BIN)/omicrob -v -device=$(DEVICE) -flash -sudo $^

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.avr

.PHONY: all flash clean
