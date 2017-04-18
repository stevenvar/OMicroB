include ../../etc/Makefile.conf

SRCS     := $(wildcard *.ml *.mli)
TARGETS  := $(BIN)/bc2c
FLAGS    := -cflags -I,+../obytelib -lflags -I,+../obytelib -libs obytelib

bc2c: $(TARGETS)

$(BIN)/bc2c: $(SRCS) config.ml
	$(OCAMLBUILD) $(FLAGS) main.native
	cp .build/main.native $@

config.ml: $(ETC)/config.ml
	cp $< $@

clean:
	@rm -f *~ config.ml $(TARGETS)
	$(OCAMLBUILD) -clean

.PHONY: bc2c clean
