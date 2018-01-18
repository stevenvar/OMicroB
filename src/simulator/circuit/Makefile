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

include ../../etc/Makefile.conf

TARG = $(BIN)/ocapic_circuit_simulator
SRCS = $(wildcard *.ml *.mli *.mll *.mly)
BUILD = main.native
EXTRA = $(LIB)/extra
LCD = $(SRC)/simulator/lcd/_build
LCD_MODS = \
  types.cmx,config.cmx,cgrom.cmx,cgram.cmx,ddram.cmx,display.cmx,proto.cmx
CFLAGS = -thread,-I,$(EXTRA),-I,$(LCD)
LFLAGS = $(CFLAGS),unix.cmxa,graphics.cmxa,threads.cmxa,simul.cmx,$(LCD_MODS)
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

simu_circuit: $(TARG)

$(TARG): _build/$(BUILD)
	cp $< $@

_build/$(BUILD): $(SRCS)
	$(OCAMLBUILD) $(OPTIONS) $(BUILD)
	@touch $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ $(TARG)

.PHONY: simu_circuit clean
