#
# Custom Makefile for MkDocs
#

compile:
	mkdocs build

serve:
	mkdocs serve

watch:
	@./scripts/watch
