include ../../etc/Makefile.conf

LIBAVR := $(LIB)/targets/avr

FOLDERS := arduino_uno arduino_mega_2560 arduboy

LIB_FOLDERS := $(foreach f,$(FOLDERS),$(LIBAVR)/$(f))

MODULES := avr
SUBMODULES := \
  arduino_uno/arduinoUnoPins \
  arduino_mega_2560/arduinoMegaPins \
  arduboy/arduboyPins \

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

SMLS := $(SUBMODULES:=.ml)
SMLIS := $(SUBMODULES:=.mli)
SCMOS := $(SUBMODULES:=.cmo)
SCMIS := $(SUBMODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBAVR)/$(ml)) \
						$(foreach ml,$(SMLS),$(LIBAVR)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBAVR)/$(mli)) \
						$(foreach ml,$(SMLIS),$(LIBAVR)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBAVR)/$(cmi)) \
						$(foreach cmi,$(SCMIS),$(LIBAVR)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBAVR)/$(cmo)) \
						$(foreach cmo,$(SCMOS),$(LIBAVR)/$(cmo))

TARGETS := $(LIB_FOLDERS) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBAVR)/avr.cma

avrs: $(TARGETS)

$(LIBAVR)/avr.cma: avr.cmo
	$(OCAMLC) -a $^ -o $@

avr.cmi: avr.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

avr.cmo: avr.ml avr.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(SCMIS): %.cmi: %.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@

$(SCMOS): %.cmo: %.ml
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@ $(foreach f,$(FOLDERS), -I $(f))

$(LIB_FOLDERS):
	mkdir -p $@

$(LIBAVR)/%.ml: %.ml
	cp $< $@

$(LIBAVR)/%.mli: %.mli
	cp $< $@

$(LIBAVR)/%.cmi: %.cmi
	cp $< $@

$(LIBAVR)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f $(CMOS) $(CMIS) $(SCMOS) $(SCMIS)

.PHONY: avrs clean
