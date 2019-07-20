BASEDIR=src
SOURCEFILES=header.sh variables.sh glyphs.sh color.sh options.sh core.sh modules.sh venv.sh vcs.sh tools.sh notes.sh
OUTPUT=bash-prompt-package.sh

all: clean
	@cd src ; cat ${SOURCEFILES} > ../${OUTPUT}
	$(info Compiled ${SOURCEFILES} to ${OUTPUT})

clean:
	rm ${OUTPUT} 2> /dev/null || true

compile: ${SOURCEFILES}
	@echo $^

