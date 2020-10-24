include ../../../etc/Makefile.conf

uno: i2cscreen.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o i2cscreen.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo i2cscreen.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean uno flash-uno
