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

TARG = $(BIN)/omicrob_lcd_16x2_simulator
SRCS = $(wildcard *.ml)
BUILD = main.native
EXTRA = $(LIB)/extra
CFLAGS = -thread,-I,$(EXTRA)
LFLAGS = -thread,unix.cmxa,graphics.cmxa,threads.cmxa,-I,$(EXTRA),simul.cmx
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

simu_lcd: $(TARG)

$(TARG): .build/$(BUILD)
	cp $< $@

.build/$(BUILD): $(SRCS) config.ml $(EXTRA)/simul.ml $(EXTRA)/simul.mli
	$(OCAMLBUILD) $(OPTIONS) $(BUILD)
	@touch $@

config.ml: $(ETC)/config.ml
	cp $< $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ config.ml $(TARG)

.PHONY: simu_lcd clean
