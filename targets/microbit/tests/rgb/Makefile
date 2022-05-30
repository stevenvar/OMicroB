include ../../../../etc/Makefile.conf

DEVICE ?= microbit2

TARGETS := mbrgb.elf mbrgb.hex

all: $(TARGETS)

$(TARGETS): mbrgb.ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.map
