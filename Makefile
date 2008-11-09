# This Makefile contains only a simple dist rule to generate a distribution
# tarball.  The software is designed to run from this tree, copied to
# /srv/control, so there are no other rules (there may be an install rule
# later to copy the key bits to /srv/control).

VERSION := $(shell grep '^control-archive' NEWS | head -1 | cut -d' ' -f 2)

dist:
	git archive --prefix=control-archive-$(VERSION)/ master \
	    | gzip -9c > control-archive-$(VERSION).tar.gz
