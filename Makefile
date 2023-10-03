#
# Custom Makefile for MkDocs
#

compile:
	pipenv run mkdocs build

serve:
	pipenv run mkdocs serve

watch:
	@./scripts/watch
