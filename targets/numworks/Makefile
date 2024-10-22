include ../../etc/Makefile.conf

LIBNUMWORKS := $(LIB)/targets/numworks

MODULES := numworks

MLS := $(MODULES:=.ml)
MLIS := $(MODULES:=.mli)
CMOS := $(MODULES:=.cmo)
CMIS := $(MODULES:=.cmi)

LIB_MLS  := $(foreach ml,$(MLS),$(LIBNUMWORKS)/$(ml)) \
						$(foreach ml,$(SMLS),$(LIBNUMWORKS)/$(ml))
LIB_MLIS := $(foreach mli,$(MLIS),$(LIBNUMWORKS)/$(mli)) \
						$(foreach ml,$(SMLIS),$(LIBNUMWORKS)/$(ml))
LIB_CMIS := $(foreach cmi,$(CMIS),$(LIBNUMWORKS)/$(cmi)) \
						$(foreach cmi,$(SCMIS),$(LIBNUMWORKS)/$(cmi))
LIB_CMOS := $(foreach cmo,$(CMOS),$(LIBNUMWORKS)/$(cmo)) \
						$(foreach cmo,$(SCMOS),$(LIBNUMWORKS)/$(cmo))

TARGETS := $(LIBNUMWORKS) $(LIB_MLS) $(LIB_MLIS) $(LIB_CMIS) $(LIB_CMOS) $(LIBNUMWORKS)/numworks.cma

numworks: $(TARGETS)

$(LIBNUMWORKS)/numworks.cma: numworks.cmo
	$(OCAMLC) -a $^ -o $@

numworks.cmi: numworks.mli
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

numworks.cmo: numworks.ml numworks.cmi
	CAMLLIB=$(LIB) $(OCAMLC) -c -w @a $< -o $@

$(LIBNUMWORKS):
	mkdir -p $@

$(LIBNUMWORKS)/%.ml: %.ml
	cp $< $@

$(LIBNUMWORKS)/%.mli: %.mli
	cp $< $@

$(LIBNUMWORKS)/%.cmi: %.cmi
	cp $< $@

$(LIBNUMWORKS)/%.cmo: %.cmo
	cp $< $@

clean:
	@rm -f $(CMOS) $(CMIS) $(SCMOS) $(SCMIS)

.PHONY: numworks clean
