OMICROB :=	omicrob -device microbit -v -no-shortcut-initialization -stack-size 200

TARGETS := gcd.hex gcd.elf

all: $(TARGETS)

gcd.elf: gcd.ml
	$(OMICROB) -o $@ $^

gcd.hex: gcd.ml
	$(OMICROB) -o $@ $^

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)
	@rm -rf  *.elf.*

.PHONY: all gcd clean

################################################################################

