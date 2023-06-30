include ../etc/Makefile.conf

BENCHS := \
	apply2/apply2 \
	fibo/fibo \
	takc2/takc2 \
	abrsort/abrsort \
	queens/queens \
	integrales_tr/integrales_tr

OMICROB_BYTE := $(BENCHS:=.omicrob.byte)
OCAMLRUN_BYTE := $(BENCHS:=.ocamlrun.byte)

all: $(OMICROB_BYTE) $(OCAMLRUN_BYTE)

%.omicrob.byte: %.ml
	$(BIN)/omicrob -device microbit $^ -o $@

%.cmo: %.ml
	ocamlc -c -o $@ unix.cma $^

%.ocamlrun.byte: %.ml ocamlrunHarness.cmo
	ocamlc -o $@ unix.cma ocamlrunHarness.cmo -open OcamlrunHarness $<

flash: test.hex
	$(BIN)/omicrob -flash -sudo $<

simul: test.elf
	./$<

clean:
	@rm -f *.cmo *.cmi
	@rm -f $(OMICROB_BYTE) $(OCAMLRUN_BYTE)

.PHONY: all flash clean
