all: startup.o

CC = arm-none-eabi-gcc
NWLINK = npx --yes -- nwlink@0.0.16

CFLAGS = -std=c99
CFLAGS += $(shell $(NWLINK) eadk-cflags)
CFLAGS += -Os -Wall
CFLAGS += -ggdb
LDFLAGS = -Wl,--relocatable
LDFLAGS += -nostartfiles
LDFLAGS += --specs=nano.specs

AR = arm-none-eabi-ar

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean: force
	rm -f *.hex *.elf *.map *.o

.PHONY: examples

# Don't delete intermediate files
.SECONDARY:

force:

###

$(MICROBIAN): microbian.h
