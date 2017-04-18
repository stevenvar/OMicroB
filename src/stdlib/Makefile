include ../../etc/Makefile.conf

MLS  := $(wildcard *.ml)
MLIS := $(wildcard *.mli)
CMOS := $(MLS:.ml=.cmo)
CMIS := $(MLIS:.mli=.cmi)

TARGETS := $(LIB)/stdlib.cma $(LIB)/std_exit.cmo $(foreach cmi,$(CMIS),$(LIB)/$(cmi))

stdlib: $(TARGETS)

$(LIB)/stdlib.cma: $(CMOS)
	ocamlc -a $^ -o $@

%.cmi: %.mli
	ocamlc -nostdlib -c -w @a $<

%.cmo: %.ml $(CMIS)
	ocamlc -nostdlib -c -w @a $<

pervasives.cmi: pervasives.mli
	ocamlc -nostdlib -nopervasives -c -w @a $<

pervasives.cmo: pervasives.ml pervasives.cmi
	ocamlc -nostdlib -nopervasives -c -w @a $<

$(LIB)/%.cmi: %.cmi
	cp $< $@

$(LIB)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f *.cmo *.cmi *.cmx *.cma *.cmxa *.o $(TARGETS)

.PHONY: stdlib clean
