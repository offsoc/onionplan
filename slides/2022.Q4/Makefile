#
# Makefile for The Onion Plan slides
#

SOURCE   = usability.md
TARGET   = usability.pdf
TEMPLATE = beamer-ahf-slim.tex

export TEXINPUTS:=$(shell pwd)/../../vendors/onion-tex-slim/src/tex:${TEXINPUTS}

all: $(TARGET)

$(TARGET): $(SOURCE)
	pandoc -t beamer --pdf-engine=pdflatex --slide-level 2 --template="../../vendors/onion-tex-slim/src/pandoc/templates/$(TEMPLATE)" $(SOURCE) -o $(TARGET)

clean:
	rm *.pdf || true
