include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem1421
CFLAGS   := -mmcu=atmega328p -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -g -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := ofacto.byte ofacto.c ofacto.elf ofacto.avr ofacto.hex

ofacto: $(TARGETS)

run: ofacto.elf
	./ofacto.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: ofacto run clean flash

################################################################################

ofacto.byte: ofacto.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun $^ -o $@
	ocamlclean $@ -o $@

ofacto.c: ofacto.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 64 -stack-size 64 $< -o $@

ofacto.elf: ofacto.c
	$(GCC) -m32 -D__PC__ -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g -std=c99 -D_POSIX_C_SOURCE=199309L -DDEBUG  -Wall $^ -o $@

################################################################################

ofacto.avr: $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp) $(wildcard stdlib/*/*.cpp) ofacto.c
	$(AVR_GXX) -O3  -I$(SRC)/byterun/ -D__ARDUINO__ -D__OMICROB_WITH_ARDUBOY__ $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall $^ -o $@

ofacto.hex: ofacto.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: ofacto.avr
	stty -f $(ATTY) 1200
	sleep 1
	$(AVRDUDE) -c arduino -P $(ATTY) -p ATmega328p -b 115200 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	tail -f $(ATTY)

################################################################################
