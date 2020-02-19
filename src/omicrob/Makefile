include ../../etc/Makefile.conf

TARGETS := $(BIN)/omicrob

omicrob: $(TARGETS)

$(BIN)/omicrob: config.ml tools.ml  device_config.ml omicrob.ml
	$(OCAMLOPT) -w @a -safe-string -strict-formats -strict-sequence unix.cmxa $^ -o $@

config.ml: $(ETC)/config.ml
	cp $< $@

clean:
	@rm -f *.cmo *.cmi *.cmx *~ 

.PHONY: omicrob clean
