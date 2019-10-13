all: startup.o microbitlib.o

CPU = -mcpu=cortex-m0 -mthumb
CFLAGS = -Os -g -Wall -fdata-sections -ffunction-sections
LDFLAGS = -Wl,--gc-sections
CC = arm-none-eabi-g++

%.o: %.c
	$(CC) $(CPU) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
