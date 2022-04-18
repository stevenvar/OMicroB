
include ../../../etc/Makefile.conf

TARG = $(BIN)/omicrob_lcd_simulator
SRCS = $(wildcard *.ml)
BUILD = main.native
EXTRA = $(LIB)/extra
CFLAGS = -thread,-I,$(EXTRA),-I,+../graphics
LFLAGS = $(CFLAGS),unix.cmxa,graphics.cmxa,threads.cmxa,simul.cmx
OPTIONS = -cflags $(CFLAGS) -lflags $(LFLAGS)

lcd: $(TARG)

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

.PHONY: lcd clean
