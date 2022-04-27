include ../../../../etc/Makefile.conf

DEVICE ?= microbit2

TARGETS := mbpixels.elf mbpixels.hex

all: $(TARGETS)

$(TARGETS): mbpixels.ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
