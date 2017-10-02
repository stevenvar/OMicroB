include ../../etc/Makefile.conf

ATTY   := /dev/ttyACM0
CFLAGS := -mmcu=atmega2560 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -g -Os -w -fno-exceptions
LFLAGS := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/

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
	CAMLLIB=$(LIB) ocamlc -custom $< -o $@
	ocamlclean $@ -o $@

blink.c: blink.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 $< -o $@

blink.elf: blink.c
	$(GCC) -g -std=c99 -D_POSIX_C_SOURCE=199309L -DDEBUG -Wall $< -o $@

################################################################################

blink.avr: blink.c $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp)
	$(AVR_GXX) $(INCLUDES) $(CFLAGS) $(LFLAGS) $^ -o $@

blink.hex: blink.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: blink.avr
	$(AVRDUDE) -D -c wiring -p ATmega2560 -P /dev/ttyACM0 -b 115200 -U flash:w:$<:e

listen:
	stty -F $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
