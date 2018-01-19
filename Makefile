include etc/Makefile.conf

all: config
	$(call compile, lib/extra)
	$(call compile, src/bc2c)
	$(call compile, src/simulators/lcd)
	$(call compile, src/simulators/dip)
	$(call compile, src/byterun)
	$(call compile, src/omicrob)
	$(call compile, src/stdlib)


config:
	@if [ $(ETC)/Makefile.conf -ot VERSION -o                     \
             $(ETC)/Makefile.conf -ot configure ]; then               \
          echo 'Configuration files are not up to date.' 1>&2;        \
	  echo 'Please run `./configure` (with right options).' 1>&2; \
          exit 1;                                                     \
	fi

install: all
	mkdir -p "$(LIBDIR)"
	mkdir -p "$(BINDIR)"
	mkdir -p "$(MAN1DIR)"
	mkdir -p "$(MAN3DIR)"
	cp bin/bc2c "$(BINDIR)/bc2c"
	cp bin/omicrob "$(BINDIR)/omicrob"
	cp man/bc2c.1.gz "$(MAN1DIR)/bc2c.1.gz"
	cp man/omicrob.1.gz "$(MAN1DIR)/omicrob.1.gz"
	cp lib/stdlib.cma "$(LIBDIR)/stdlib.cma"
	cp lib/libcamlrun.a "$(LIBDIR)/libcamlrun.a"
	cp lib/*.ml "$(LIBDIR)/"
	cp lib/*.mli "$(LIBDIR)/"
	cp lib/*.cmo "$(LIBDIR)/"
	cp lib/*.cmi "$(LIBDIR)/"

uninstall:
	-rm -f "$(BINDIR)/bc2c"
	-rm -f "$(BINDIR)/omicrob"
	-rm -f "$(MAN1DIR)/omicrob.1.gz"
	-rm -f "$(MAN1DIR)/bc2c.1.gz"
	-rm -f "$(LIBDIR)/stdlib.cma"
	-rm -f "$(LIBDIR)/libcamlrun.a"
	-rm -f "$(LIBDIR)/"*.ml
	-rm -f "$(LIBDIR)/"*.mli
	-rm -f "$(LIBDIR)/"*.cmi
	-rm -f "$(LIBDIR)/"*.cmo
	@for mod in $(MAN_3P_BASES); do \
	  rm -f "$(MAN3DIR)/"$$mod.3p;	\
	done
	@for mod in $(MAN_3O_BASES); do \
	  rm -f "$(MAN3DIR)/"$$mod.3o;	\
	done
	@if [ -d "$(LIBDIR)" ]; then rmdir "$(LIBDIR)"; fi

etc/Makefile.conf:
	@echo "You must run ./configure before" 1>&2
	@exit 1

tests: all
	@make --no-print-directory -C tests

clean:
	@rm -f *~ */*~ */*/*~ */*/*/*~
	$(call clean, src/bc2c)
	$(call clean, src/byterun)
	$(call clean, src/simulators/dip)
	$(call clean, src/simulators/lcd)
	$(call clean, src/omicrob)
	$(call clean, src/stdlib)
	$(call clean, lib/extra)

.PHONY: all config install uninstall tests clean
