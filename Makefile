#!/usr/bin/make

INSTALL_PATH=~/.bashrc.d/

BASEDIR=src

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

install: compile
	mkdir -p "${INSTALL_PATH}" && cp "${OUTPUT}" "${INSTALL_PATH}"

test: clean
	bats tests
