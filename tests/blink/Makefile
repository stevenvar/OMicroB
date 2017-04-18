include ../../etc/Makefile.conf

################################################################################

TARGETS := blink.c

blink: $(TARGETS)

run: blink.byte
	./blink.byte

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: blink run clean

################################################################################

blink.byte: blink.ml
	CAMLLIB=$(LIB) ocamlc -custom $< -o $@
	ocamlclean $@ -o $@

blink.c: blink.byte $(BIN)/bc2c
	$(BIN)/bc2c -local $< -o $@

################################################################################
