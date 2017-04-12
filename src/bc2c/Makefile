include ../../etc/Makefile.conf
SRCS     := $(wildcard *.ml *.mli)
TARGETS  := $(BIN)/bc2c
FLAGS    := -cflags -I,+../obytelib -lflags -I,+../obytelib -libs obytelib

bc2c: $(TARGETS)

$(BIN)/bc2c: $(SRCS)
	$(OCAMLBUILD) $(FLAGS) main.native
	cp .build/main.native $@

clean:
	@rm -f *~ $(TARGETS)
	$(OCAMLBUILD) -clean 

.PHONY: bc2c clean
