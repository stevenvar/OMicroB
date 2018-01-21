include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem14331
CFLAGS   := -mmcu=atmega32u4
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I$(SRC)/stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := test.byte test.c test.elf test.avr test.hex

test: $(TARGETS)

run: test.elf
	./test.elf ../../bin/omicrob_pin_simulator

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)
	@rm -rf *.elf.dSYM

.PHONY: test run clean flash

################################################################################

test.byte: test.ml
	CAMLLIB=$(LIB) ocamlc -custom $^ -o $@
	ocamlclean $@ -o $@

test.c: test.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 512 -stack-size 64 $< -o $@

test.elf: test.c
	$(GCC) -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g $(OPT) $^ -o $@

################################################################################

test.avr: $(wildcard $(SRC)/stdlib/*.c) test.c
	$(AVR_GXX) -fpermissive -O2 $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall $^ -Wnarrowing -o $@

test.hex: test.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: test.avr
#	stty -f $(ATTY) 1200
#	sleep 0
	$(AVRDUDE) -c avr109 -P $(ATTY) -p ATmega32U4 -b 57600 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
