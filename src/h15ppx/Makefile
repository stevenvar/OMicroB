include ../../etc/Makefile.conf

TARGETS := $(BIN)/h15ppx

h15ppx: $(TARGETS)

$(BIN)/h15ppx: h15ppx.ml
	$(OCAMLOPT) -w -42 -I +compiler-libs ocamlcommon.cmxa ocamloptcomp.cmxa $< -o $@

clean:
	@rm -Rf *.cmo *.cmi *.cmx *.o $(TARGETS)

.PHONY: h15ppx clean
