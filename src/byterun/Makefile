include ../../etc/Makefile.conf

TARGETS := $(LIB)/libcamlrun.a

byterun: $(TARGETS)

$(LIB)/libcamlrun.a: runtime.o
	@rm -f $@
	cp $(OCAMLWHERE)/libcamlrun.a $@
	ar rs $@ $^

%.o: %.c
	gcc -c -Wall -Os $<

clean:
	@rm -f *.o *.a *.elf *~ $(TARGETS)

.PHONY: byterun clean
