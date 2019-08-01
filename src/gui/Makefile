include ../../etc/Makefile.conf

MLS := editor.ml term.ml omicrobide.ml

TARGETS := $(BIN)/omicrobide

omicrobide: $(TARGETS)

$(BIN)/omicrobide: $(MLS)
	$(OCAMLFIND) ocamlc -thread -g -package lablgtk3 -linkpkg $^ -o $@

clean:
	@rm -f *.cmo *.cmi *.cmx $(TARGETS)

.PHONY: omicrobide clean
