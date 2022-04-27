include ../../../../etc/Makefile.conf

DEVICE ?= microbit2

mbacc.hex: mbacc.ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.hex
