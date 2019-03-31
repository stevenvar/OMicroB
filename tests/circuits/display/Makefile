include ../../../etc/Makefile.conf

uno: display.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o display.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo display.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean uno flash-uno
