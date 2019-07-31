include ../../etc/Makefile.conf

MLS := omicrobide.ml

TARGETS := $(BIN)/omicrobide

omicrobide: $(TARGETS)

$(BIN)/omicrobide: $(MLS)
	$(OCAMLFIND) ocamlc -g -package lablgtk2 -linkpkg $^ -o $@

clean:
	@rm -f *.cmo *.cmi *.cmx $(TARGETS)

.PHONY: omicrobide clean
