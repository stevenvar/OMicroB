include ../../etc/Makefile.conf

TARGETS = $(BIN)/circuitppx

$(BIN)/circuitppx: component.ml gate.ml connect.ml multiact.ml circuitppx.ml
	$(OCAMLOPT) -w -42 -I +compiler-libs ocamlcommon.cmxa ocamloptcomp.cmxa $^ -o $@

clean:
	rm -rf *.cmi *.cmo *.cmx *.o
