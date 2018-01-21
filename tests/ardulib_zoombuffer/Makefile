include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem14331
# CFLAGS   := -mmcu=atmega32u4 -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
CFLAGS   := -mmcu=atmega32u4
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I$(SRC)/stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := ardulib.byte ardulib.c ardulib.elf ardulib.avr ardulib.hex

ardulib: $(TARGETS)

run: ardulib.elf
	./ardulib.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)
	@rm -Rf *.elf.dSYM

.PHONY: ardulib run clean flash

################################################################################

simul : ardulib.elf
	./ardulib.elf '../../bin/omicrob_circuit_simulator circuit.txt'
	#./ardulib.elf '../../bin/omicrob_lcd_simulator 128x8 dc=PIN4 cs=PIN12 rst=PIN6'

ardulib.byte: buffer.c spi.ml oled.ml ardulib.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun -ccopt -D__OCAML__ $^ -o $@
	ocamlclean $@ -o $@

ardulib.c: ardulib.byte $(BIN)/bc2c
	$(BIN)/bc2c -i buffer.c -local -arch 32 -heap-size 100 -stack-size 64 $< -o $@

ardulib.elf: ardulib.c
	$(GXX) -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g $(OPT) $^ -o $@

################################################################################

ardulib.avr: $(wildcard $(SRC)/stdlib/*.c) lib/buffer.c ardulib.c
	$(AVR_GXX) -fpermissive -O2 $(INCLUDES) -I lib $(CFLAGS) $(LFLAGS) -Wall  $^ -Wnarrowing -o $@

ardulib.hex: ardulib.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: ardulib.avr
	stty -f $(ATTY) 1200
	sleep 0
	$(AVRDUDE) -c avr109 -P $(ATTY) -p ATmega32U4 -b 57600 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################
