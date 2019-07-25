#!/usr/bin/make

BASEDIR=src
# Customize the output location
# eg OUTPUT=my-bpp.sh make
OUTPUT ?= bash-prompt-package.sh

# All files
SOURCEFILES=header.sh variables.sh glyphs.sh color.sh named_colors.sh default_colors.sh options.sh core.sh modules.sh example_prompts.sh venv.sh vcs.sh tools.sh notes.sh

# Allow us to build a subset of modules
# e.g. TARGETS="header.sh variables.sh glyphs.sh color.sh core.sh modules.sh" make
# A minimal build  with minmal functionality.
TARGETS ?= ${SOURCEFILES}

all: clean compile
	$(info Compiled ${TARGETS} to ${OUTPUT})

clean:
	rm ${OUTPUT} 2> /dev/null || true

compile: clean
	for X in ${TARGETS}; do \
	   cat ${BASEDIR}/$$X >> ${OUTPUT}; \
	done

test: clean
	bats tests
