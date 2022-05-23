include ../../../../etc/Makefile.conf

DEVICE ?= microbit2

TARGETS := mbio.elf mbio.hex

all: $(TARGETS)

$(TARGETS): mbio.ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.map
