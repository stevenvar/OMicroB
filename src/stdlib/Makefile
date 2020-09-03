include ../../etc/Makefile.conf

BASES :=                                                         \
  char bytes bytesLabels string stringLabels                     \
  list listLabels map array arrayLabels uchar sys buffer random  \
  complex gc int32 int64 obj hashtbl set moreLabels queue sort   \
  stack stdLabels circuits

MODULES := stdlib $(BASES) camlinternalOO std_exit

STDLIB_MODULES := stdlib $(foreach m,$(BASES),stdlib__$(m)) camlinternalOO std_exit

MLS  := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(STDLIB_MODULES:=.cmo)
CMIS := $(STDLIB_MODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIB)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIB)/$(mli))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIB)/$(cmi))

TARGETS := $(LIB)/stdlib.cma $(LIB)/stdlib.cmo $(LIB)/std_exit.cmo $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS)

stdlib: $(TARGETS)

$(LIB)/stdlib.cma: $(CMOS)
	$(OCAMLC) -a $^ -o $@

stdlib__%.cmi: $(SRC)/stdlib/%.mli stdlib.cmi
	$(OCAMLC) -absname -nostdlib -c -w @a $< -o $@

stdlib__%Labels.cmo: $(SRC)/stdlib/%Labels.ml $(CMIS)
	$(OCAMLC) -absname -nostdlib -nolabels -c -w @a-4 $< -o $@

stdlib__%.cmo: $(SRC)/stdlib/%.ml $(CMIS)
	$(OCAMLC) -absname -nostdlib -c -w @a $< -o $@

stdlib.cmi: stdlib.mli
	$(OCAMLC) -absname -no-alias-deps -nostdlib -nopervasives -c -w @a-49-4 $<

stdlib.cmo: stdlib.ml stdlib.cmi
	$(OCAMLC) -absname -no-alias-deps -nostdlib -nopervasives -c -w @a-49-4 $<

camlinternalOO.cmo: camlinternalOO.ml camlinternalOO.cmi
	$(OCAMLC) -nostdlib -c -w @a-41 $<

camlinternalOO.cmi: camlinternalOO.mli
	$(OCAMLC) -nostdlib -c $<

std_exit.cmo: std_exit.ml std_exit.cmi
	$(OCAMLC) -nostdlib -c $<

std_exit.cmi: std_exit.mli
	$(OCAMLC) -nostdlib -c $<

stdlib__obj.cmi: stdlib__int32.cmi
camlinternalOO.cmi: stdlib__obj.cmi stdlib__string.cmi stdlib__char.cmi stdlib__map.cmi stdlib__array.cmi stdlib__sys.cmi stdlib__list.cmi

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
