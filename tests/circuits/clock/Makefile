include ../../../etc/Makefile.conf

microbit: clock.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o clock.combined_hex

uno: clock.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o clock.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo clock.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
