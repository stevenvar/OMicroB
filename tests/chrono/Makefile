include ../../etc/Makefile.conf

SOURCES := chrono.ml
TARGETS := chrono.byte chrono.elf chrono.hex

DEVICE ?= arduino-uno

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -device $(DEVICE) \
	-circuitppx -mlopts -ppx,"ocalustre -m chrono" \
	-v $^

simul: chrono.elf
	./$^ \
	'$(BIN)/omicrob_pin_simulator -device $(DEVICE)' \
	'$(BIN)/omicrob_circuit_simulator -device $(DEVICE) circuit.txt' \
	'$(BIN)/omicrob_lcd_16x2_simulator -device=$(DEVICE) -e=PIN12 -rs=PIN11 -rw=PIN0 -d4=PIN2 -d5=PIN3 -d6=PIN4 -d7=PIN5 16x2'

clean:
	@rm -f *~ *.o *.cmo *.cmi $(TARGETS)

.PHONY: all simul clean
