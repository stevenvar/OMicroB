include ../../etc/Makefile.conf

SOURCES := test.ml
TARGETS := test.byte test.c test.elf

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose -stack-size 200 -heap-size 200 -o test.elf

clean:
	@rm -f *.cmo *.cmi
	@rm -f $(TARGETS)

.PHONY: all flash clean
