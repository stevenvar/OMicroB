include ../../etc/Makefile.conf

TARGETS := test.byte test.c test.elf test.avr test.hex

test: $(TARGETS)

$(TARGETS): test.ml
	../../bin/omicrob -local $^

flash: test.hex
	../../bin/omicrob -flash -sudo $^

simul: test.elf
	./test.elf ../../bin/omicrob_pin_simulator

clean:
	@rm -f *.cmo *.cmi *.cmx *.o $(TARGETS)

.PHONY: test clean
