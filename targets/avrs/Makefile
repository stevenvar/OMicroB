include ../../etc/Makefile.conf

LIBAVRS := $(LIB)/archs/avrs

FOLDERS := arduino_uno arduino_mega_2560 arduboy

LIB_FOLDERS := $(foreach f,$(FOLDERS),$(LIBAVRS)/$(f))

MODULES := avr liquidCrystal
SUBMODULES := arduino_uno/arduinoUnoPins \
							arduboy/arduboyPins \
							arduino_mega_2560/arduinoMegaPins

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

SMLS := $(SUBMODULES:=.ml)
SMLIS := $(SUBMODULES:=.mli)
SCMOS := $(SUBMODULES:=.cmo)
SCMIS := $(SUBMODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBAVRS)/$(ml)) \
						$(foreach ml,$(SMLS),$(LIBAVRS)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBAVRS)/$(mli)) \
						$(foreach ml,$(SMLIS),$(LIBAVRS)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBAVRS)/$(cmi)) \
						$(foreach cmi,$(SCMIS),$(LIBAVRS)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBAVRS)/$(cmo)) \
						$(foreach cmo,$(SCMOS),$(LIBAVRS)/$(cmo))

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

$(SCMIS): %.cmi: %.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@

$(SCMOS): %.cmo: %.ml
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@ $(foreach f,$(FOLDERS), -I $(f))

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
	@rm -f $(CMOS) $(CMIS) $(SCMOS) $(SCMIS)

.PHONY: avrs clean
