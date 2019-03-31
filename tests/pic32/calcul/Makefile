include ../../../etc/Makefile.conf

SOURCES := calcul.ml
TARGETS := calcul.byte calcul.c calcul.elf calcul.pic32_elf calcul.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v -flash -device fubarino-mini $^ -mlopt -verbose -stack-size 200 -heap-size 200

clean:
	@rm -f *.cmo *.cmi
	@rm -f sketch.ld.*
	@rm -f $(TARGETS)

.PHONY: all clean
