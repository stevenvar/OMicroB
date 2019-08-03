include ../../etc/Makefile.conf

MLS := editor.ml term.ml config.ml omicrobide.ml

TARGETS := $(BIN)/omicrobide

omicrobide: $(TARGETS)

config.ml: $(ETC)/config.ml
	cp $^ $@

$(BIN)/omicrobide: $(MLS)
	$(OCAMLFIND) ocamlc -thread -g -package lablgtk3 \
	lablgtksourceview3.cma \
	-linkpkg $^ -o $@

clean:
	@rm -f *.cmo *.cmi *.cmx config.ml $(TARGETS)

.PHONY: omicrobide clean
