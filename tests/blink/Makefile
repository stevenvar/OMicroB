include ../../etc/Makefile.conf

################################################################################

TARGETS := blink.byte blink.c blink.elf

blink: $(TARGETS)

run: blink.elf
	./blink.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: blink run clean

################################################################################

blink.byte: blink.ml
	CAMLLIB=$(LIB) ocamlc -custom $< -o $@
	ocamlclean $@ -o $@

blink.c: blink.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 64 $< -o $@

blink.elf: blink.c
	gcc -g -std=c99 -D_POSIX_C_SOURCE=199309L -Wall $< -o $@

################################################################################
