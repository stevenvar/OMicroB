include ../../../../etc/Makefile.conf

TARGETS := mbpixels.elf mbpixels.hex

all: $(TARGETS)

$(TARGETS): mbpixels.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
