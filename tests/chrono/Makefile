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

clean:
	@rm -f *~ *.o *.cmo *.cmi $(TARGETS)

.PHONY: all simul clean
