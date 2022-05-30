include ../../../etc/Makefile.conf

DEVICE ?= microbit

all: rgb.hex

rgb.hex: rgb.ml
	$(BIN)/omicrob -v -device=$(DEVICE) -circuitppx $^ -o $@

flash: rgb.hex
	$(BIN)/omicrob -v -device=$(DEVICE) -flash -sudo $^

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.avr

.PHONY: all flash clean
