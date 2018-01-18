###########################################################################
##                                                                       ##
##                                OCaPIC                                 ##
##                                                                       ##
##                             Benoit Vaugon                             ##
##                                                                       ##
##    This file is distributed under the terms of the CeCILL license.    ##
##    See file ../../../LICENSE-en.                                      ##
##                                                                       ##
###########################################################################

include ../../../etc/Makefile.conf

TARG = $(BIN)/ocapic_keyboard_simulator
SRCS = $(wildcard *.ml)
BUILD = main.native
EXTRA = $(LIB)/extra
CFLAGS = -thread,-I,$(EXTRA)
LFLAGS = -thread,unix.cmxa,graphics.cmxa,threads.cmxa,-I,$(EXTRA),simul.cmx
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

simu_lcd: $(TARG)

$(TARG): _build/$(BUILD)
	cp $< $@

_build/$(BUILD): $(SRCS) $(EXTRA)/simul.ml $(EXTRA)/simul.mli
	$(OCAMLBUILD) $(OPTIONS) $(BUILD)
	@touch $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ $(TARG)

.PHONY: simu_lcd clean
