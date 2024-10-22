include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

HEADERS := $(wildcard */*.h)

OBJECTS :=              \
  .build/bindings.o     \
  .build/random.o       \
  .build/trace.o        \
  .build/gc.o           \
  .build/format.o       \
  .build/sf-regs.o      \
  .build/shared.o       \
  .build/simul.o

byterun: $(TARGETS) $(ARCHS)

$(LIB)/libcamlrun.a: $(OBJECTS)
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $(OBJECTS)

.build/%.o: prims/%.c $(HEADERS)
	mkdir -p .build/
	$(OCAMLC) -c -ccopt -Wall -ccopt -D__OCAML__ $<
	mv -f $*.o .build/

.build/%.o: stdlib/%.c $(HEADERS)
	mkdir -p .build/
	$(OCAMLC) -c -ccopt -Wall -ccopt -D__OCAML__ $<
	mv -f $*.o .build/

.build/%.o: simul/%.c $(HEADERS)
	$(OCAMLC) -c -ccopt -Wall -ccopt -D__OCAML__ $<
	mv -f $*.o .build/

clean:
	@rm -Rf .build/ $(TARGETS)

microbit: microbit/accel.c microbit/adc.c microbit/lib.c microbit/radio.c microbit/serial.c microbit/timer.c microbit/lib.c microbit/microbian.c microbit/startup.c
	$(MAKE) -C microbit

numworks: numworks/startup.c
	$(MAKE) -C numworks

.PHONY: byterun clean $(ARCHS)
