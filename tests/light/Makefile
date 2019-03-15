include ../../etc/Makefile.conf

SOURCES := light_ocalustre.ml
TARGETS := light_ocalustre.byte light_ocalustre.c light_ocalustre.elf light_ocalustre.avr light_ocalustre.hex
ATTY := /dev/ttyACM0

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -gc MAC -arch 16 -no-flash-heap -stack-size 300 -heap-size 2000 -avrcxxopt -DF_CPU=16000000L 
	# $(BIN)/omicrob -v $^ -gc SC -arch 16 -no-flash-heap -no-flash-globals -stack-size 300 -heap-size 800

flash: light_ocalustre.hex
	sudo ./reset.py $(ATTY)
	$(BIN)/omicrob -v -flash -sudo $<


simul: light_ocalustre.elf
	./$< '../../bin/omicrob_pin_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
