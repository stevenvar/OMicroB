include ../../../../etc/Makefile.conf

TARGETS := mbbasic.elf mbbasic.hex

all: $(TARGETS)

$(TARGETS): mbbasic.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
