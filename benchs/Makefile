include ../etc/Makefile.conf

BENCHS := \
	apply2/apply2 \
	fibo/fibo \
	takc2/takc2 \
	abrsort/abrsort \
	queens/queens \
	integrales_tr/integrales_tr

ARM_CXX_FLAGS := \
	-mcpu=cortex-m0 -mthumb \
	-g -fno-exceptions -fno-unwind-tables \
	-O2 -g -Wall -Wl,-Os \
	-fdata-sections -ffunction-sections \
	-Wl,--gc-sections


OMICROB_BYTE := $(BENCHS:=.omicrob.byte)
OCAMLRUN_BYTE := $(BENCHS:=.ocamlrun.byte)
OMICROB_ARM_HEX := $(BENCHS:=.arm.hex)
OMICROB_AVR_HEX := $(BENCHS:=.avr.hex)
C_EXE := $(BENCHS:=-c.exe)
C_ARM_ELF := $(BENCHS:=-c.arm_elf)
C_ARM_HEX := $(BENCHS:=-c.arm.hex)

TARGETS := $(OCAMLRUN_BYTE) \
	$(OMICROB_BYTE) $(OMICROB_ARM_HEX) $(OMICROB_AVR_HEX) \
	$(C_EXE) $(C_ARM_ELF) $(C_ARM_HEX)

all: $(TARGETS)

%.omicrob.byte: %.ml
	$(BIN)/omicrob -device microbit $^ -o $@

%.cmo: %.ml
	ocamlc -c -o $@ unix.cma $^

%.ocamlrun.byte: %.ml ocamlrunHarness.cmo
	ocamlc -o $@ unix.cma ocamlrunHarness.cmo -open OcamlrunHarness $<

%.arm.hex: %.ml
	$(BIN)/omicrob -device microbit $^ -o $@

%.avr.hex: %.ml
	$(BIN)/omicrob -device arduino-uno $^ -o $@

%.o: %.c
	gcc -c -o $@ $^

%-c.exe:%-c.c gccHarness.o
	gcc -o $@ $^

%-c.arm_o:%-c.c
	arm-none-eabi-gcc $(ARM_CXX_FLAGS) \
		-D__MICROBIT__ \
		-I $(INCLUDEDIR)/microbit \
		-o $@ -c $^ \

%-c.arm_elf:%-c.arm_o
	arm-none-eabi-gcc $(ARM_CXX_FLAGS) \
		-specs=nosys.specs \
		-D__MICROBIT__ \
		-T $(INCLUDEDIR)/microbit/nRF51822.ld -nostdlib \
		$^ $(INCLUDEDIR)/microbit/startup1.o $(INCLUDEDIR)/microbit/microbian1.a \
		-lm -lc -lgcc -lnosys \
		-o $@

%-c.arm.hex:%-c.arm_elf
	arm-none-eabi-objcopy -O ihex $^ $@

benchpc.native: benchpc.ml
	ocamlopt -o $@ unix.cmxa $^

benchpc: benchpc.native $(TARGETS)
	./$< $(BENCHS)

flash: test.hex
	$(BIN)/omicrob -flash -sudo $<

simul: test.elf
	./$<

clean:
	@rm -f **/*.cmo **/*.cmi **/*.byte **/*.exe **/*.arm_* **/*.hex

.PHONY: all flash clean benchpc
