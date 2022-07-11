SOURCES := thermo_io.ml temp.ml
TARGETS := temp.byte temp.c temp.elf temp.avr temp.hex

DEVICE ?= arduino-uno

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	omicrob -device $(DEVICE) -circuitppx -mlopts -ppx,"ocalustre -m thermo" -v $^ -stack-size 70 -heap-size 200 -arch 16 -gc SC

simul: temp.elf
	./$<  'omicrob_circuit_simulator circuit.txt' '~/OCaml/OMicroB/bin/omicrob_lcd_16x2_simulator e=PIN12 rs=PIN13 rw=PIN3 d4=PIN18 d5=PIN19 d6=PIN20 d7=PIN21 16x2' 'omicrob_pin_simulator'

flash: temp.hex
	omicrob -device $(DEVICE) -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
