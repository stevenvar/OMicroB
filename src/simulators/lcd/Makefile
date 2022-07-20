
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_lcd_simulator
SRCS = $(wildcard *.ml)
BUILD = main.native
SIMUL = $(SRC)/simulators
CFLAGS = -thread,-I,$(SIMUL),-I,+../graphics
LFLAGS = $(CFLAGS),unix.cmxa,graphics.cmxa,threads.cmxa,simul.cmx,simul_config.cmxa
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

lcd: $(TARG)

$(TARG): .build/$(BUILD)
	cp $< $@

.build/$(BUILD): $(SRCS) config.ml $(SIMUL)/simul.ml $(SIMUL)/simul.mli
	$(OCAMLBUILD) $(OPTIONS) $(BUILD)
	@touch $@

config.ml: $(ETC)/config.ml
	cp $< $@

clean:
	@$(OCAMLBUILD) -clean
	@rm -f *~ config.ml $(TARG)

.PHONY: lcd clean
