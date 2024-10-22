include ../../../../etc/Makefile.conf

PROG = hello
DEVICE ?= numworks

TARGETS := $(PROG).elf $(PROG).hex

all: $(TARGETS)

$(TARGETS): $(PROG).ml
	$(BIN)/omicrob -v -device=$(DEVICE) $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
