include ../../etc/Makefile.conf

NAME := test_spi
SOURCES := spi.ml oled.ml arduboy.ml $(NAME).ml
TARGETS := $(NAME).byte $(NAME).c $(NAME).elf $(NAME).avr $(NAME).hex

all: $(TARGETS)

$(TARGETS): $(SOURCES)
	$(BIN)/omicrob -no-flash-heap -no-flash-globals -v -mlopts -ppx,ocalustre $^ -mlopt -verbose -stack-size 64 -heap-size 300 -arch 16

flash: snake.hex
	$(BIN)/omicrob -flash -sudo $<

simul: snake.elf
	./$< '../../bin/omicrob_circuit_simulator circuit.txt'

clean:
	@rm -f *.cmo *.cmi
	@rm -rf *.elf.dSYM
	@rm -f $(TARGETS)

.PHONY: all flash clean
