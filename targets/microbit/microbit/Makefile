all: startup.o microbitlib.o

CPU = -mcpu=cortex-m0 -mthumb
CFLAGS = -O -g -Wall
CC = arm-none-eabi-g++

%.o: %.c
	$(CC) $(CPU) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o
