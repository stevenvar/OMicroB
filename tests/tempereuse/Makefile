SOURCES := thermo_io.ml temp.ml
TARGETS := temp.byte temp.c temp.elf temp.avr temp.hex

DEVICE ?= arduino-mega

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	../../bin/omicrob -device $(DEVICE) -circuitppx -mlopts -ppx,"ocalustre -m thermo" -v $^ -stack-size 70 -heap-size 200 -arch 16 -gc SC

simul: temp.elf
	./$< \
	'../../bin/omicrob_circuit_simulator -device=$(DEVICE) circuit.txt' \
	'../../bin/omicrob_lcd_16x2_simulator -device=$(DEVICE) -e=PIN12 -rs=PIN11 -rw=PIN0 -d4=PIN2 -d5=PIN3 -d6=PIN4 -d7=PIN5 16x2' \
	'../../bin/omicrob_pin_simulator -device=$(DEVICE)'

flash: temp.hex
	../../bin/omicrob -device $(DEVICE) -flash -sudo $<

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
