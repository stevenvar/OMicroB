include ../../etc/Makefile.conf

MODULES := std_exit pervasives char bytes string list array random avr

MLS  := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIB)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIB)/$(mli))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIB)/$(cmi))

TARGETS :=  $(LIB)/stdlib.cma $(LIB)/std_exit.cmo $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS)

stdlib: $(TARGETS)

$(LIB)/stdlib.cma: $(CMOS)
	$(OCAMLC) -a $^ -o $@

%.cmi: $(SRC)/stdlib/%.mli
	$(OCAMLC) -nostdlib -nopervasives -c -w @a $<

%.cmo: $(SRC)/stdlib/%.ml $(CMIS)
	$(OCAMLC) -nostdlib -c -w @a $<

pervasives.cmi: pervasives.mli
	$(OCAMLC) -nostdlib -nopervasives -c -w @a $<

pervasives.cmo: pervasives.ml pervasives.cmi
	$(OCAMLC) -nostdlib -nopervasives -c -w @a $<

$(LIB)/%.mli: %.mli
	cp $< $@

$(LIB)/%.ml: %.ml
	cp $< $@

$(LIB)/%.cmi: %.cmi
	cp $< $@

$(LIB)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f *.cmo *.cmi *.cmx *.cma *.cmxa *.o $(TARGETS)

.PHONY: stdlib clean
