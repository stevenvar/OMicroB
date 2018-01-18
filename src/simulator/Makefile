
include ../../etc/Makefile.conf

SRCS = shared.c sf_regs.c simu.c cserial.c ceeprom.c stds.c
OBJS = $(SRCS:.c=.o)
FLAGS = -ccopt -Wall -ccopt -O3
LCD = $(BIN)/omicrob_lcd_simulator
# GOBLET = $(BIN)/ocapic_goblet_simulator
DIP = $(BIN)/omicrob_pin_simulator
# CIRCUIT = $(BIN)/ocapic_circuit_simulator
# KEYBOARD = $(BIN)/ocapic_keyboard_simulator
TARGS = $(OBJS) $(DIP) $(LCD)

simulator: $(TARGS)

$(LCD): lcd/*.ml
	$(call compile, lcd)

$(GOBLET): goblet/*.ml
	$(call compile, goblet)

$(DIP): dip/*.ml
	$(call compile, dip)

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
	$(call clean, lcd)
#	$(call clean, goblet)
	$(call clean, dip)
#	$(call clean, circuit)
#	$(call clean, keyboard)

.PHONY: simulator clean
