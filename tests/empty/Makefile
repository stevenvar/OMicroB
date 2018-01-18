include ../../etc/Makefile.conf

MMCU     := atmega328p
ATTY     := /dev/tty.usbmodem1411
CFLAGS   := -mmcu=$(MMCU) -DF_CPU=16000000L -Os -w -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES :=  -I$(SRC)/byterun/

################################################################################

TARGETS := blink.byte blink.c blink.elf blink.avr blink.hex

blink: $(TARGETS)

run: blink.elf
	./blink.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: blink run clean flash

################################################################################

blink.byte: blink.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun $^ -o $@
	ocamlclean $@ -o $@

blink.c: blink.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 1 -stack-size 1 $< -o $@

blink.elf: blink.c
	$(GCC) -I $(OCAMLWHERE) -I$(SRC)/byterun/$(INCLUDES)  -g -std=c99 -D_POSIX_C_SOURCE=199309L -Wall $^ -o $@

################################################################################

blink.avr: blink.c
	$(AVR_GXX) -O2 -I$(SRC)/byterun/ -D__AVR__  $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall $^ -o $@

blink.hex: blink.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: blink.avr
	stty -f $(ATTY) 1200
	sleep 3
	$(AVRDUDE) -c arduino -P $(ATTY) -p $(MMCU) -b 115200 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
