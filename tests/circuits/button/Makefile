include ../../../etc/Makefile.conf

DEVICE ?= arduino-uno

all: button.hex

button.hex: button.ml
	$(BIN)/omicrob -v -device=$(DEVICE) -circuitppx $^ -o $@

flash: button.hex
	$(BIN)/omicrob -v -device=$(DEVICE) -flash -sudo $^

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.avr

.PHONY: all flash clean
