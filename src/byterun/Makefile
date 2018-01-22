include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

HEADERS := $(wildcard */*.h)

OBJECTS :=              \
  .build/std-bindings.o \
  .build/random.o       \
  .build/trace.o        \
  .build/sf-regs.o      \
  .build/shared.o       \
  .build/simul.o

byterun: $(TARGETS)

$(LIB)/libcamlrun.a: $(OBJECTS)
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $(OBJECTS)

.build/%.o: prims/%.c $(HEADERS)
	mkdir -p .build/
	ocamlc -c -ccopt -Wall $<
	mv $*.o .build/

.build/%.o: stdlib/%.c $(HEADERS)
	mkdir -p .build/
	ocamlc -c -ccopt -Wall $<
	mv $*.o .build/

.build/%.o: simul/%.c $(HEADERS)
	ocamlc -c -ccopt -Wall $<
	mv $*.o .build/

clean:
	@rm -Rf .build/ $(TARGETS)

.PHONY: byterun clean
