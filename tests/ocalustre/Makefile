include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem14331
CFLAGS   := -mmcu=atmega32u4 -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -g -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := ocalustre.byte ocalustre.c ocalustre.elf ocalustre.avr ocalustre.hex

ocalustre: $(TARGETS)

run: ocalustre.elf
	./ocalustre.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: ocalustre run clean flash

################################################################################

ocalustre.byte: ocalustre.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun $^ -o $@
	ocamlclean $@ -o $@

ocalustre.c: ocalustre.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 1 -stack-size 1 $< -o $@

ocalustre.elf: ocalustre.c
	$(GCC) -D__PC__ -I $(OCAMLWHERE) -I$(SRC)/byterun/ -DOMICROB_WITH_ARDUBOY -g -std=c99 -D_POSIX_C_SOURCE=199309L -DDEBUG -Wall $^ -o $@

################################################################################

ocalustre.avr: $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp) $(wildcard stdlib/*/*.cpp) ocalustre.c
	$(AVR_GXX)  -O2 -I$(SRC)/byterun/ -DOMICROB_WITH_ARDUBOY $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall $^ -o $@

ocalustre.hex: ocalustre.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: ocalustre.avr
	stty -f $(ATTY) 1200
	sleep 3
	$(AVRDUDE) -c avr109 -P $(ATTY) -p ATmega32U4 -b 57600 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
