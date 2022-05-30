include ../../../../etc/Makefile.conf

DEVICE ?= microbit2

TARGETS := mbanalog.elf mbanalog.hex

all: $(TARGETS)

$(TARGETS): mbanalog.ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.map
