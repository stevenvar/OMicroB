include ../../../etc/Makefile.conf

uno: light.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o light.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo light.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean uno flash-uno
