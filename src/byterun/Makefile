include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

byterun: $(TARGETS)

$(LIB)/libcamlrun.a: debug.o prims.o stdlib.o simul.o gc.o
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $^

%.o: %.c
	ocamlc -c -ccopt -Wall -ccopt -Os -ccopt -DDEBUG -ccopt -DOCAML_VIRTUAL_ARCH=32 -ccopt -DOCAML_HEAP_WOSIZE=1 -ccopt -DOCAML_STACK_WOSIZE=1 -ccopt -DOCAML_GLOBDATA_NUMBER=1 $<

clean:
	@rm -f *.o *.a *.elf *~ $(TARGETS)

.PHONY: byterun clean
