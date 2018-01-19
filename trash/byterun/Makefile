include ../../etc/Makefile.conf

HEADERS := $(wildcard *.h)
TARGETS := $(LIB)/libcamlrun.a

OBJECTS :=  \
  debug.o   \
  prims.o   \
  stdlib.o  \
  gc.o      \
  simu.o    \
  shared.o  \
  sf_regs.o

CONSTANTS :=                          \
 -ccopt -DOCAML_VIRTUAL_ARCH=32       \
 -ccopt -DOCAML_HEAP_WOSIZE=2         \
 -ccopt -DOCAML_HEAP_INITIAL_WOSIZE=0 \
 -ccopt -DOCAML_STACK_WOSIZE=1        \
 -ccopt -DOCAML_GLOBDATA_NUMBER=1     \
 -ccopt -DDEBUG

byterun: $(TARGETS)

$(LIB)/libcamlrun.a: $(OBJECTS)
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $(OBJECTS)

%.o: %.c $(HEADERS)
	ocamlc -c -ccopt -Wall $(CONSTANTS) $<

clean:
	@rm -f *.o *.a *.elf *~ $(TARGETS)

.PHONY: byterun clean
