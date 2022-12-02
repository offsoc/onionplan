#
# Custom Makefile for The Onion Plan
#

compile:
	mkdocs build

serve:
	mkdocs serve

watch:
	@./scripts/watch
