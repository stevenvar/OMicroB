
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_circuit_simulator
SRCS = $(wildcard *.ml *.mli *.mll *.mly)
BUILD = main.native
EXTRA = $(LIB)/extra
CFLAGS = -thread,-I,$(EXTRA),-I,+../graphics
LFLAGS = $(CFLAGS),unix.cmxa,graphics.cmxa,threads.cmxa,simul.cmx #,$(LCD_MODS)
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

simu_circuit: $(TARG)

$(TARG): .build/$(BUILD)
	cp $< $@

.build/$(BUILD): $(SRCS)
	@rm -f $@
	$(OCAMLBUILD) $(OPTIONS) $(BUILD)
	@touch $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ $(TARG)

.PHONY: simu_circuit clean
