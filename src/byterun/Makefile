include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

simulator/%.o : simulator/%.c
	$(MAKE) -C simulator

byterun: simulator/simu.o $(TARGETS)

$(LIB)/libcamlrun.a: debug.o prims.o stdlib.o simul.o simulator/simu.o simulator/shared.o simulator/sf_regs.o gc.o
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $^




%.o: %.c
	ocamlc -c -ccopt -Wall -ccopt -Os -ccopt -DDEBUG -ccopt -DOCAML_VIRTUAL_ARCH=32 -ccopt -DOCAML_HEAP_WOSIZE=1 -ccopt -DOCAML_STACK_WOSIZE=1 -ccopt -DOCAML_GLOBDATA_NUMBER=1 $<

clean:
	$(MAKE) clean -C simulator
	@rm -f *.o *.a *.elf *~ $(TARGETS)

.PHONY: byterun clean
