#
# Onion Plan Makefile.
#

# Relative folder pointing to where the Onion MkDocs is installed
ONION_MKDOCS_PATH = vendors/onion-mkdocs

# Include the Onion MkDocs Makefile
# See https://www.gnu.org/software/make/manual/html_node/Include.html
-include vendors/onion-mkdocs/Makefile.onion-mkdocs
