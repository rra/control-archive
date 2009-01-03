# This Makefile contains only simple dist and install rule to generate a
# distribution tarball and copy the software to /srv/control.  The software
# doesn't need any compilation, so there are no other rules.

VERSION := $(shell grep '^control-archive' NEWS | head -1 | cut -d' ' -f 2)

dist:
	git archive --prefix=control-archive-$(VERSION)/ master \
	    | gzip -9c > control-archive-$(VERSION).tar.gz

control.ctl:
	mkdir -p keyring
	gpg --homedir=keyring --allow-non-selfsigned-uid --import keys/*
	scripts/generate-files

install: control.ctl
	mkdir -p /srv/control
	cd /srv/control && mkdir -p archive export keyring logs scripts \
	    spool tmp
	install -m 755 -p scripts/control-summary scripts/export-control \
	    scripts/process-control scripts/update-control \
	    scripts/weekly-report /srv/control/scripts/
	install -m 644 -p docs/config-policy /srv/control/export/README
	install -m 644 -p docs/hierarchies /srv/control/export/HIERARCHY-NOTES
	install -m 644 -p docs/archive-policy /srv/control/archive/README
	gpg --homedir=/srv/control/keyring --allow-non-selfsigned-uid \
	    --import keys/*
	install -m 644 control.ctl /srv/control/
