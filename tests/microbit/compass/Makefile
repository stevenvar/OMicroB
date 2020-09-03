include ../../../etc/Makefile.conf

mbcompass.hex: mbcompass.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex *.hex
