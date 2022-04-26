include ../../../../etc/Makefile.conf

TARGETS := mbdisplay.elf mbdisplay.hex

all: $(TARGETS)

$(TARGETS): mbdisplay.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
