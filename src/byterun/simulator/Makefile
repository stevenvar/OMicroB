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

include ../../../etc/Makefile.conf

SRCS = shared.c sf_regs.c simu.c cserial.c ceeprom.c stds.c
OBJS = $(SRCS:.c=.o)
FLAGS = -ccopt -Wall -ccopt -O3
LCD = $(BIN)/ocapic_lcd_simulator
# GOBLET = $(BIN)/ocapic_goblet_simulator
DIP40 = $(BIN)/ocapic_dip40_simulator
# CIRCUIT = $(BIN)/ocapic_circuit_simulator
# KEYBOARD = $(BIN)/ocapic_keyboard_simulator
TARGS = $(OBJS) $(DIP40) $(LCD)

simulator: $(TARGS)

$(LCD): lcd/*.ml
	$(call compile, lcd)

$(GOBLET): goblet/*.ml
	$(call compile, goblet)

$(DIP40): dip40/*.ml
	$(call compile, dip40)

$(CIRCUIT): circuit/*.ml circuit/*.mll circuit/*.mly
	$(call compile, circuit)

$(KEYBOARD): keyboard/*.ml
	$(call compile, keyboard)

# %.o: %.o
# 	cp $< $@

%.o: %.c
	$(OCAMLC) $(FLAGS) -c $<

clean:
	@rm -f *~ *.o *.a $(TARGS)
	# $(call clean, lcd)
	# $(call clean, goblet)
	$(call clean, dip40)
	# $(call clean, circuit)
	# $(call clean, keyboard)

.PHONY: simulator clean
