include ../../etc/Makefile.conf

################################################################################

TARGETS := ocamlc.byte ocamlc.c ocamlc.elf

ocamlc: $(TARGETS)

run: ocamlc.elf
	./ocamlc.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: ocamlc run clean

################################################################################

ocamlc.byte:
	cp $$(which ocamlc.byte) $@
	ocamlclean $@ -o $@

ocamlc.c: ocamlc.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 64 -heap-size 1000000 -debug $< -o $@

ocamlc.elf: ocamlc.c
	gcc -g -std=c99 -D_POSIX_C_SOURCE=199309L -Wall $< $(OCAMLWHERE)/libcamlrun.a -lm -ldl -lncurses -o $@

################################################################################
