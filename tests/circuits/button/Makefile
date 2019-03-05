include ../../../etc/Makefile.conf

microbit: button.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o button.combined_hex

uno: button.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o button.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo button.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
