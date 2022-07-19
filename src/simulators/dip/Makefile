
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_pin_simulator

dip: $(TARG)

$(TARG): atmega2560.ml atmega32u4.ml main.ml
	$(OCAMLOPT) -thread -I $(SRC)/simulators -I +../graphics unix.cmxa threads.cmxa graphics.cmxa simul.cmx $^ -o $@

clean:
	@rm -f *~ *.o *.cmi *.cmx $(TARG)

.PHONY: dip clean
