include ../../etc/Makefile.conf

LIBMICROBIT := $(LIB)/targets/microbit

MODULES := microbit

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBMICROBIT)/$(ml)) \
						$(foreach ml,$(SMLS),$(LIBMICROBIT)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBMICROBIT)/$(mli)) \
						$(foreach ml,$(SMLIS),$(LIBMICROBIT)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBMICROBIT)/$(cmi)) \
						$(foreach cmi,$(SCMIS),$(LIBMICROBIT)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBMICROBIT)/$(cmo)) \
						$(foreach cmo,$(SCMOS),$(LIBMICROBIT)/$(cmo))

TARGETS := $(LIBMICROBIT) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBMICROBIT)/microbit.cma

microbit: $(TARGETS)

$(LIBMICROBIT)/microbit.cma: microbit.cmo
	$(OCAMLC) -a $^ -o $@

microbit.cmi: microbit.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

microbit.cmo: microbit.ml microbit.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(LIBMICROBIT):
	mkdir -p $@

$(LIBMICROBIT)/%.ml: %.ml
	cp $< $@

$(LIBMICROBIT)/%.mli: %.mli
	cp $< $@

$(LIBMICROBIT)/%.cmi: %.cmi
	cp $< $@

$(LIBMICROBIT)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f $(CMOS) $(CMIS) $(SCMOS) $(SCMIS)

.PHONY: microbit clean
