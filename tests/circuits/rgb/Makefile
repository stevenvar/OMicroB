include ../../../etc/Makefile.conf

uno: rgb.ml
	$(BIN)/omicrob -v -device=arduino-uno -circuitppx $^ -o rgb.hex

flash-uno: uno
	$(BIN)/omicrob -v -device=arduino-uno -flash -sudo rgb.hex

clean:
	rm -rf *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.combined_hex *.avr

.PHONY: clean uno flash-uno
