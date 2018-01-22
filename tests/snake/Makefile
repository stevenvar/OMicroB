include ../../etc/Makefile.conf

SOURCES := buffer.c spi.ml oled.ml arduboy.ml snake.ml
TARGETS := snake.byte snake.c snake.elf snake.avr snake.hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -v $^ -mlopt -verbose

flash: snake.hex
	$(BIN)/omicrob -flash -sudo $<

simul: snake.elf
	$(BIN)/omicrob -simul $< 'omicrob_lcd_simulator 128x8 dc=PIN4 cs=PIN12 rst=PIN6'

clean:
	@rm -f $(TARGETS)

.PHONY: all flash clean
