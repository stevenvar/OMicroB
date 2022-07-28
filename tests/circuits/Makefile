include ../../etc/Makefile.conf

DIRS   := $(shell find . -mindepth 1 -maxdepth 1 -type d | cut -c3-)
BUILDS := $(foreach d,$(DIRS),build-$(d))
CLEANS := $(foreach d,$(DIRS),clean-$(d))

tests: $(BUILDS)

clean: $(CLEANS)

build-%:
	@$(MAKE) -C $*

clean-%:
	@$(MAKE) -C $* clean

.PHONY: tests clean
