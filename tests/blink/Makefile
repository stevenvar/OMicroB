include ../../etc/Makefile.conf

ATTY   := /dev/ttyACM0
CFLAGS := -mmcu=atmega2560 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -g -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
LFLAGS := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/

################################################################################

TARGETS := blink.byte blink.c blink.elf blink.avr blink.avr.hex

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
	$(BIN)/bc2c -local -arch 32 -heap-size 16 -stack-size 32 $< -o $@

blink.elf: blink.c
	$(GCC) -D__PC__ -I $(OCAMLWHERE) -g -std=c99 -w -D_POSIX_C_SOURCE=199309L -Wall $< -o $@

################################################################################

blink.pic.hex : blink.c
	mkdir  -p pic
	xc8 --chip=18f4620 -D__PIC18F $^

################################################################################

blink.avr: blink.c $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp)
	$(AVR_GXX) -D__AVR__ -DOMICROB_WITH_ARDUBOY $(INCLUDES) $(CFLAGS) $(LFLAGS) $^ -o $@

blink.avr.hex: blink.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: blink.avr
	$(AVRDUDE) -D -c wiring -p ATmega2560 -P /dev/ttyACM0 -b 115200 -U flash:w:$<:e

listen:
	stty -F $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
