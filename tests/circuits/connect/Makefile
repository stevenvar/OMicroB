include ../../../etc/Makefile.conf

microbit: connect.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o connect.combined_hex

uno: connect.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o connect.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo connect.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
