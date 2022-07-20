###########################################################################
##                                                                       ##
##                                OCaPIC                                 ##
##                                                                       ##
##                             Benoit Vaugon                             ##
##                                                                       ##
##    This file is distributed under the terms of the CeCILL license.    ##
##    See file ../../LICENSE-en.                                         ##
##                                                                       ##
###########################################################################

include ../../etc/Makefile.conf

MLS = simul.ml
MLIS = simul.mli
CMOS = $(MLS:.ml=.cmo)
CMXS = $(MLS:.ml=.cmx)
CMIS = $(MLIS:.mli=.cmi)
OBJS = $(CMIS) $(CMOS) $(CMXS)

FARCHS := $(foreach folder,$(ARCHS),$(LIB)/targets/$(folder))
I_ARCHLIBS := $(foreach folder,$(ARCHLIBS),-I .build/$(folder))
PINSMLS := $(foreach folder,$(ARCHLIBS),.build/$(folder)/*Pins.ml)

simul: $(OBJS) simul_config.cmxa

serial.cmo: serial.ml serial.cmi
	$(OCAMLC) -thread -c $<

serial.cmx: serial.ml serial.cmi
	$(OCAMLOPT) -thread -c $<

serial.cmi: serial.mli
	$(OCAMLC) -c $<

simul.cmo: simul.ml simul.cmi
	$(OCAMLC) -thread -c $<

simul.cmx: simul.ml simul.cmi
	$(OCAMLOPT) -thread -c $<

simul.cmi: simul.mli
	$(OCAMLC) -thread -c $<

simul_config.cmxa: simul_config.ml
	mkdir -p .build
	cp -r $(FARCHS) .build
	$(OCAMLOPT) -a $(PINSMLS) $^ $(I_ARCHLIBS) -o $@

clean:
	@rm -rf .build/ *~ *.cmo *.cmx *.cmxa *.cmi *.o *.3o *.a

.PHONY: simul clean
