include ../../etc/Makefile.conf

microbit: conway.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o conway.combined_hex

uno: conway.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o conway.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo conway.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
