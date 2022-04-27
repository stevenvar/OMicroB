all: startup1.o microbian1.a mpx-m0.s startup2.o microbian2.a mpx-m4.s

CPU1 = -mcpu=cortex-m0 -mthumb
CPU2 = -mcpu=cortex-m4 -mthumb
CFLAGS = -Os -g -Wall -ffreestanding
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as

DRIVERS1 = serial1.o timer1.o i2c1.o radio1.o adc1.o display1.o gpio1.o accel1.o
MICROBIAN1 = microbian1.o mpx-m0.o $(DRIVERS1) lib1.o

DRIVERS2 = serial2.o timer2.o i2c2.o radio2.o adc2.o display2.o gpio2.o accel2.o
MICROBIAN2 = microbian2.o mpx-m4.o $(DRIVERS2) lib2.o

AR = arm-none-eabi-ar

microbian1.a: $(MICROBIAN1)
	$(AR) cr $@ $^

microbian2.a: $(MICROBIAN2)
	$(AR) cr $@ $^

startup1.o: startup.c
	$(CC) -DUBIT_V1 $(CPU1) $(CFLAGS) -c $< -o $@

startup2.o: startup.c
	$(CC) -DUBIT_V2 $(CPU2) $(CFLAGS) -c $< -o $@

mpx-m0.o: mpx-m0.s
	$(AS) $(CPU1) $< -o $@

mpx-m4.o: mpx-m4.s
	$(AS) $(CPU2) $< -o $@

%1.o: %.c
	$(CC) -DUBIT_V1 -Wno-narrowing $(CPU1) $(CFLAGS) -c $< -o $@

%2.o: %.c
	$(CC) -DUBIT_V2 -Wno-narrowing $(CPU2) $(CFLAGS) -c $< -o $@

clean: force
	rm -f *.hex *.elf *.map *.o microbian1.a microbian2.a

.PHONY: examples

# Don't delete intermediate files
.SECONDARY:

force:

###

$(MICROBIAN): microbian.h
