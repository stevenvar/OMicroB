include ../../etc/Makefile.conf

LIBAVR := $(LIB)/targets/avr

FOLDERS := arduino_uno/ arduino_mega_2560/ arduboy/

LIB_FOLDERS := $(foreach f,$(FOLDERS),$(LIBAVR)/$(f))

MODULES := avr
SUBMODULES := \
  arduino_uno/arduinoUno \
  arduino_mega_2560/arduinoMega \
  arduboy/arduboy \

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

PINSMLS := $(SUBMODULES:=Pins.ml)
PINSCMIS := $(SUBMODULES:=Pins.cmi)
PINSCMOS := $(SUBMODULES:=Pins.cmo)

MCUMLS := $(FOLDERS:=mcuPins.ml)
MCUMLIS := $(FOLDERS:=mcuPins.mli)
MCUCMOS := $(FOLDERS:=mcuPins.cmo)
MCUCMIS := $(FOLDERS:=mcuPins.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBAVR)/$(ml)) \
			$(foreach ml,$(PINSMLS),$(LIBAVR)/$(ml)) \
			$(foreach ml,$(MCUMLS),$(LIBAVR)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBAVR)/$(mli)) \
			$(foreach ml,$(MCUMLIS),$(LIBAVR)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBAVR)/$(cmi)) \
			$(foreach cmi,$(PINSCMIS),$(LIBAVR)/$(cmi)) \
			$(foreach cmi,$(MCUCMIS),$(LIBAVR)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBAVR)/$(cmo)) \
			$(foreach cmo,$(PINSCMOS),$(LIBAVR)/$(cmo)) \
			$(foreach cmo,$(MCUCMOS),$(LIBAVR)/$(cmo))

TARGETS := $(LIB_FOLDERS) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBAVR)/avr.cma

avrs: $(TARGETS)

$(LIBAVR)/avr.cma: avr.cmo
	$(OCAMLC) -a $^ -o $@

avr.cmi: avr.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

avr.cmo: avr.ml avr.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(PINSCMIS): %.cmi: %.ml
	$(OCAMLC) -nopervasives -nostdlib -c $< -I $*

$(PINSCMOS): %.cmo: %.ml
	$(OCAMLC) -nopervasives -nostdlib -c $< -o $@ -I $*

$(MCUCMIS): %/mcuPins.cmi: %/mcuPins.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@ -I $*

$(MCUCMOS): %/mcuPins.cmo: %/mcuPins.ml %/mcuPins.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@ -I $*

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
	@rm -f **/*.cmo **/*.cmi

.PHONY: avrs clean
