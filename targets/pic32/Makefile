include ../../etc/Makefile.conf

LIBPIC32 := $(LIB)/targets/pic32

FOLDERS := lchip fubarino_mini pro_mx7

LIB_FOLDERS := $(foreach f,$(FOLDERS),$(LIBPIC32)/$(f))

MODULES := pic32
SUBMODULES := lchip/lchipPins \
							lchip/lchipADC \
							lchip/lchipUarts \
							lchip/lchipTimers \
							fubarino_mini/fubarinoMiniPins \
							pro_mx7/proMX7Pins \
							pro_mx7/proMX7ADC \
							pro_mx7/proMX7Uarts \
							pro_mx7/proMX7Timers

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

SMLS := $(SUBMODULES:=.ml)
SMLIS := $(SUBMODULES:=.mli)
SCMOS := $(SUBMODULES:=.cmo)
SCMIS := $(SUBMODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBPIC32)/$(ml)) \
						$(foreach ml,$(SMLS),$(LIBPIC32)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBPIC32)/$(mli)) \
						$(foreach ml,$(SMLIS),$(LIBPIC32)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBPIC32)/$(cmi)) \
						$(foreach cmi,$(SCMIS),$(LIBPIC32)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBPIC32)/$(cmo)) \
						$(foreach cmo,$(SCMOS),$(LIBPIC32)/$(cmo))

TARGETS := $(LIB_FOLDERS) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBPIC32)/pic32.cma

pics: $(TARGETS)

$(LIBPIC32)/pic32.cma: pic32.cmo 
	$(OCAMLC) -a $^ -o $@

pic32.cmi: pic32.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

pic32.cmo: pic32.ml pic32.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(SCMIS): %.cmi: %.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@

$(SCMOS): %.cmo: %.ml
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $^ -o $@ $(foreach f,$(FOLDERS), -I $(f))

$(LIB_FOLDERS):
	mkdir -p $@

$(LIBPIC32)/%.ml: %.ml
	cp $< $@

$(LIBPIC32)/%.mli: %.mli
	cp $< $@

$(LIBPIC32)/%.cmi: %.cmi
	cp $< $@

$(LIBPIC32)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f $(CMOS) $(CMIS) $(SCMOS) $(SCMIS)

.PHONY: pics clean
