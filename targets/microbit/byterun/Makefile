all: startup.o microbian.a mpx-m4.s

CPU = -mcpu=cortex-m4 -mthumb
CFLAGS = -Os -g -Wall -ffreestanding
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as

DRIVERS = serial.o timer.o i2c.o radio.o adc.o display.o gpio.o accel.o
MICROBIAN = microbian.o mpx-m4.o $(DRIVERS) lib.o

AR = arm-none-eabi-ar

microbian.a: $(MICROBIAN)
	$(AR) cr $@ $^

%.o: %.s
	$(AS) $(CPU) $< -o $@

%.o: %.c
	$(CC) -Wno-narrowing $(CPU) $(CFLAGS) -c $< -o $@

clean: force
	rm -f *.hex *.elf *.map *.o microbian.a

.PHONY: examples

# Don't delete intermediate files
.SECONDARY:

force:

###

$(MICROBIAN): microbian.h
