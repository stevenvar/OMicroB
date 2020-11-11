include ../../../../etc/Makefile.conf

mbserial.hex: mbserial.ml
	$(BIN)/omicrob -v -device=microbit $^ -o $@

clean:
	rm -f *.cmi *.cmo *.byte *.c *.arm_o *.elf *.arm_elf *.hex
