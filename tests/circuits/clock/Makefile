include ../../../etc/Makefile.conf

DEVICE ?= arduino-uno

all: clock.hex

clock.hex: clock.ml
	$(BIN)/omicrob -v -device=$(DEVICE) -circuitppx $^ -o $@

flash: clock.hex
	$(BIN)/omicrob -v -device=$(DEVICE) -flash -sudo $^

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.avr

.PHONY: all flash clean
