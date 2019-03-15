include ../../../etc/Makefile.conf

microbit: rgb.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o rgb.combined_hex

uno: rgb.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o rgb.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo rgb.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
