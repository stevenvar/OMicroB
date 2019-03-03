include ../../../etc/Makefile.conf

microbit: led.ml
	$(BIN)/omicrob -v -device=microbit -circuitppx $^ -o led.combined_hex

uno: led.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o led.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo led.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean microbit uno flash-uno
