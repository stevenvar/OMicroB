include ../../../etc/Makefile.conf

SOURCES := fade.ml
TARGETS := fade.byte fade.c fade.elf fade.pic32_elf fade.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v -flash -device fubarino-mini $^ -mlopt -verbose -stack-size 200 -heap-size 200

clean:
	@rm -f *.cmo *.cmi
	@rm -f sketch.ld.*
	@rm -f $(TARGETS)

.PHONY: all clean
