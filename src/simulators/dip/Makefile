
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_pin_simulator

dip: $(TARG)

$(TARG): main.ml
	$(OCAMLOPT) -thread -I $(SRC)/simulators \
	-I +../graphics unix.cmxa threads.cmxa graphics.cmxa simul.cmx simul_config.cmxa $^ -o $@

clean:
	@rm -f *~ *.o *.cmi *.cmx $(TARG)

.PHONY: dip clean
