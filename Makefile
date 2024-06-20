#
# Onion Plan Makefile.
#

# Relative folder pointing to where the Onion MkDocs is installed
ONION_MKDOCS_PATH = vendors/onion-mkdocs

# This is useful when developing locally and Onion MkDocs is not yet installed
vendoring:
	@test   -e $(ONION_MKDOCS_PATH) && git -C $(ONION_MKDOCS_PATH) pull || true
	@test ! -e $(ONION_MKDOCS_PATH) && git clone https://gitlab.torproject.org/tpo/web/onion-mkdocs.git $(ONION_MKDOCS_PATH) || true

# Include the Onion MkDocs Makefile
# See https://www.gnu.org/software/make/manual/html_node/Include.html
-include $(ONION_MKDOCS_PATH)/Makefile.onion-mkdocs
