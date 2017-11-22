include ../../etc/Makefile.conf

ATTY     := /dev/tty.usbmodem1421
CFLAGS   := -mmcu=atmega328p -DUSB_VID=0x2341 -DUSB_PID=0x8036 -DF_CPU=16000000L -DARDUINO=105 -ffunction-sections -fdata-sections -g -Os -w -fno-exceptions -I/usr/share/arduino/hardware/arduino/cores/arduino/avr-libc
LFLAGS   := -Wl,-Os -Wl,--gc-sections
INCLUDES := -I./stdlib/ -I$(SRC)/byterun/

################################################################################

TARGETS := oderiv.byte oderiv.c oderiv.elf oderiv.avr oderiv.hex

oderiv: $(TARGETS)

run: oderiv.elf
	./oderiv.elf

clean:
	@rm -f *.cmi *.cmo *.cmx *.o *~ *.byte $(TARGETS)

.PHONY: oderiv run clean flash

################################################################################

oderiv.byte: oderiv.ml
	CAMLLIB=$(LIB) ocamlc -custom -I $(SRC)/byterun $^ -o $@
	ocamlclean $@ -o $@

oderiv.c: oderiv.byte $(BIN)/bc2c
	$(BIN)/bc2c -local -arch 32 -heap-size 94 -stack-size 28 $< -o $@

oderiv.elf: oderiv.c
	$(GCC) -m32 -D__PC__ -I $(OCAMLWHERE) -I$(SRC)/byterun/ -g -std=c99 -D_POSIX_C_SOURCE=199309L -DDEBUG  -Wall $^ -o $@

################################################################################

oderiv.avr: $(wildcard stdlib/*.c) $(wildcard stdlib/*.cpp) $(wildcard stdlib/*/*.cpp) oderiv.c
	$(AVR_GXX) -O2  -I$(SRC)/byterun/ -D__ARDUINO__ $(INCLUDES) $(CFLAGS) $(LFLAGS) -Wall $^ -o $@

oderiv.hex: oderiv.avr
	$(AVR_OBJCOPY) -O ihex -R .eeprom $< $@

flash: oderiv.avr
	stty -f $(ATTY) 1200
	sleep 1
	$(AVRDUDE) -c arduino -P $(ATTY) -p ATmega328p -b 115200 -v -D -U flash:w:$<:e
	# $(AVRDUDE) -c stk500v2 -P $(ATTY) -p m2560 -b 115200 -v -D -U flash:w:$<:e

listen:
	stty -f $(ATTY) cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
	tail -f $(ATTY)

################################################################################
