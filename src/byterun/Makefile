include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

HEADERS := $(wildcard */*.h)

OBJECTS :=              \
  .build/std-bindings.o \
  .build/sf-regs.o      \
  .build/shared.o       \
  .build/simul.o

all: $(TARGETS)

$(LIB)/libcamlrun.a: $(OBJECTS)
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $(OBJECTS)

.build/%.o: prims/%.c .build/ $(HEADERS)
	ocamlc -c -ccopt -Wall $<
	mv $*.o .build/

.build/%.o: simul/%.c .build/ $(HEADERS)
	ocamlc -c -ccopt -Wall $<
	mv $*.o .build/

.build/:
	mkdir .build/

clean:
	@rm -Rf .build/ $(TARGETS)

.PHONY: all clean
