include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem14611
# CFLAGS   := -mmcu=atmega32u4 -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
CFLAGS   := -mmcu=atmega32u4
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := solilet_simul.byte solilet_simul.c solilet_simul.elf solilet_simul.avr solilet_simul.hex

solilet_simul: $(TARGETS)

run: solilet_simul.elf
	./solilet_simul.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: solilet_simul run clean flash

################################################################################

solilet_simul.byte: spi.ml oled.ml solilet_simul.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun $^ -o $@
	ocamlclean $@ -o $@

solilet_simul.c: solilet_simul.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 164 -stack-size 164 $< -o $@

solilet_simul.elf: solilet_simul.c
#	$(GCC) -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g -std=c99 -D_POSIX_C_SOURCE=199309L -Wnarrowing -DDEBUG $^ -o $@
	$(GCC) -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g -std=c99 -D_POSIX_C_SOURCE=199309L $^ -o $@

################################################################################

solilet_simul.avr: $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp) $(wildcard stdlib/*/*.cpp) solilet_simul.c
	$(AVR_GXX) -O2 $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall  $^  -Wnarrowing -o $@

solilet_simul.hex: solilet_simul.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

simul : solilet_simul.byte
	./solilet_simul.byte ../../bin/ocapic_dip40_simulator

flash: solilet_simul.avr
	stty -f $(ATTY) 1200
	sleep 3
	$(AVRDUDE) -c avr109 -P $(ATTY) -p ATmega32U4 -b 57600 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
