include ../../etc/Makefile.conf

LIBAVRS := $(LIB)/archs/avrs

FOLDERS := arduino_uno arduino_mega_2560 arduboy

LIB_FOLDERS := $(foreach f,$(FOLDERS),$(LIBAVRS)/$(f))

MODULES := avr liquidCrystal

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBAVRS)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBAVRS)/$(mli))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBAVRS)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBAVRS)/$(cmo))

TARGETS := $(LIB_FOLDERS) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBAVRS)/avr.cma

avrs: $(TARGETS)

$(LIBAVRS)/avr.cma: avr.cmo liquidCrystal.cmo
	$(OCAMLC) -a $^ -o $@

avr.cmi: avr.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

avr.cmo: avr.ml avr.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

liquidCrystal.cmi: liquidCrystal.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

liquidCrystal.cmo: liquidCrystal.ml liquidCrystal.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(LIB_FOLDERS):
	mkdir -p $@

$(LIBAVRS)/%.ml: %.ml
	cp $< $@

$(LIBAVRS)/%.mli: %.mli
	cp $< $@

$(LIBAVRS)/%.cmi: %.cmi
	cp $< $@

$(LIBAVRS)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f *.cmi *.cmo *.cmx *.o

.PHONY: avrs clean
