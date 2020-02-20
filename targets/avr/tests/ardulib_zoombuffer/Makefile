include ../../../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem14331
# CFLAGS   := -mmcu=atmega32u4 -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
CFLAGS   := -mmcu=atmega32u4
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I$(SRC)/stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := ardulib.byte ardulib.c ardulib.elf ardulib.avr ardulib.hex

ardulib: $(TARGETS)

$(TARGETS): spi.ml oled.ml ardulib.ml
	$(BIN)/omicrob -mlopts -I,lib,buffer.c -bc2copts -i,buffer.c \
		-v $^ -device arduboy

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)
	@rm -Rf *.elf.dSYM

################################################################################

run: ardulib.elf
	./ardulib.elf

simul : ardulib.elf
	./ardulib.elf '../../bin/omicrob_circuit_simulator circuit.txt'
	#./ardulib.elf '../../bin/omicrob_lcd_simulator 128x8 dc=PIN4 cs=PIN12 rst=PIN6'

################################################################################

flash: ardulib.avr
	stty -f $(ATTY) 1200
	sleep 0
	$(AVRDUDE) -c avr109 -P $(ATTY) -p ATmega32U4 -b 57600 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	cat $(ATTY)

################################################################################

.PHONY: ardulib run clean flash
