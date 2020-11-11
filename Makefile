include etc/Makefile.conf

all: internals $(ARCHS)

internals: config
	$(call compile, lib/extra)
	$(call compile, src/bc2c)
	$(call compile, src/h15ppx)
	$(call compile, src/simulators/lcd)
	$(call compile, src/simulators/lcd_16x2)
	$(call compile, src/simulators/dip)
	$(call compile, src/simulators/circuit)
	$(call compile, src/byterun)
	$(call compile, src/omicrob)
	$(call compile, src/stdlib)

avr: internals
	$(call compile, targets/avr)

microbit: internals
	$(call compile, targets/microbit)

pic32: internals
	$(call compile, targets/pic32)

config:
	@if [ $(ETC)/Makefile.conf -ot VERSION -o                     \
             $(ETC)/Makefile.conf -ot configure ]; then               \
          echo 'Configuration files are not up to date.' 1>&2;        \
	  echo 'Please run `./configure` (with right options).' 1>&2; \
          exit 1;                                                     \
	fi

install: all
	mkdir -p "$(LIBDIR)"
	mkdir -p "$(LIBEXECDIR)"
	mkdir -p "$(INCLUDEDIR)"
	mkdir -p "$(BINDIR)"
	mkdir -p "$(MAN1DIR)"
	mkdir -p "$(MAN3DIR)"
	cp bin/bc2c "$(BINDIR)/bc2c"
	cp bin/h15ppx "$(BINDIR)/h15ppx"
	cp bin/omicrob "$(BINDIR)/omicrob"
	cp bin/*_simulator "$(LIBEXECDIR)/"
	cp doc/bc2c.1 "$(MAN1DIR)/bc2c.1"
	cp doc/omicrob.1 "$(MAN1DIR)/omicrob.1"
	cp lib/stdlib.cma "$(LIBDIR)/stdlib.cma"
	cp lib/libcamlrun.a "$(LIBDIR)/libcamlrun.a"
	cp lib/*.ml "$(LIBDIR)/"
	cp lib/*.mli "$(LIBDIR)/"
	cp lib/*.cmo "$(LIBDIR)/"
	cp lib/*.cmi "$(LIBDIR)/"
	cp lib/lcd_cgrom.txt "$(LIBDIR)/"
	cp -a lib/extra "$(LIBDIR)/"
	cp -a lib/targets "$(LIBDIR)/"
	cp -a src/byterun/vm "$(INCLUDEDIR)/"
	cp -a src/byterun/prims "$(INCLUDEDIR)/"
	cp -a src/byterun/simul "$(INCLUDEDIR)/"
	cp -a src/byterun/avr "$(INCLUDEDIR)" 2> /dev/null || :
	cp -a src/byterun/pic32 "$(INCLUDEDIR)/" 2> /dev/null || :
	cp -a src/byterun/microbit "$(INCLUDEDIR)/" 2> /dev/null || :
	cp -a src/byterun/stdlib "$(INCLUDEDIR)/"

uninstall:
	-rm -f "$(BINDIR)/bc2c"
	-rm -f "$(BINDIR)/h15ppx"
	-rm -f "$(BINDIR)/omicrob"
	-rm -f "$(MAN1DIR)/omicrob.1"
	-rm -f "$(MAN1DIR)/bc2c.1"
	-rm -f "$(LIBDIR)/stdlib.cma"
	-rm -f "$(LIBDIR)/libcamlrun.a"
	-rm -f "$(LIBDIR)/"*.ml
	-rm -f "$(LIBDIR)/"*.mli
	-rm -f "$(LIBDIR)/"*.cmi
	-rm -f "$(LIBDIR)/"*.cmo
	-rm -f "$(LIBDIR)/lcd_cgrom.txt"
	-rm -rf "$(LIBDIR)/extra"
	-rm -f "$(LIBEXECDIR)/"*_simulator
	-rm -f "$(INCLUDEDIR)/vm/"*
	-rm -f "$(INCLUDEDIR)/prims/"*
	-rm -f "$(INCLUDEDIR)/simul/"*
	-rm -rf "$(INCLUDEDIR)/$(TARGET)/"*
	-rm -f "$(INCLUDEDIR)/stdlib/"*
	@for mod in $(MAN_3P_BASES); do \
	  rm -f "$(MAN3DIR)/"$$mod.3p;	\
	done
	@for mod in $(MAN_3O_BASES); do \
	  rm -f "$(MAN3DIR)/"$$mod.3o;	\
	done
	@if [ -d "$(LIBDIR)" ]; then rmdir "$(LIBDIR)"; fi
	@if [ -d "$(LIBEXECDIR)" ]; then rmdir "$(LIBEXECDIR)"; fi
	@if [ -d "$(INCLUDEDIR)/vm" ]; then rmdir "$(INCLUDEDIR)/vm"; fi
	@if [ -d "$(INCLUDEDIR)/prims" ]; then rmdir "$(INCLUDEDIR)/prims"; fi
	@if [ -d "$(INCLUDEDIR)/simul" ]; then rmdir "$(INCLUDEDIR)/simul"; fi
	@if [ -d "$(INCLUDEDIR)/$(TARGET)" ]; then rmdir "$(INCLUDEDIR)/$(TARGET)"; fi
	@if [ -d "$(INCLUDEDIR)/stdlib" ]; then rmdir "$(INCLUDEDIR)/stdlib"; fi
	@if [ -d "$(INCLUDEDIR)" ]; then rmdir "$(INCLUDEDIR)"; fi

etc/Makefile.conf:
	@echo "You must run ./configure before" 1>&2
	@exit 1

tests: all
	@make --no-print-directory -C tests

clean:
	@rm -f *~ */*~ */*/*~ */*/*/*~
	@rm -f bin/*
	$(call clean, src/bc2c)
	$(call clean, src/h15ppx)
	$(call clean, src/byterun)
	$(call clean, src/simulators/dip)
	$(call clean, src/simulators/lcd_16x2)
	$(call clean, src/simulators/lcd)
	$(call clean, src/simulators/circuit)
	$(call clean, src/omicrob)
	$(call clean, src/stdlib)
	$(call clean, lib/extra)
	$(call clean, targets/avr)
	$(call clean, targets/pic32)
	$(call clean, targets/microbit)

.PHONY: all config install uninstall tests clean
