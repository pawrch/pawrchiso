#
# SPDX-License-Identifier: GPL-3.0-or-later

PREFIX ?= /usr/local
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/pawrchiso
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man
PROFILE_DIR=$(DESTDIR)$(PREFIX)/share/pawrchiso

DOC_FILES=$(wildcard docs/*) $(wildcard *.rst)
SCRIPT_FILES=$(wildcard pawrchiso/*) $(wildcard scripts/*.sh) $(wildcard .gitlab/ci/*.sh) \
             $(wildcard configs/*/profiledef.sh) $(wildcard configs/*/airootfs/usr/local/bin/*)
VERSION?=$(shell git describe --long --abbrev=7 | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g;s/\.r0\.g.*//')

all:

check: shellcheck

shellcheck:
	shellcheck -s bash $(SCRIPT_FILES)

install: install-scripts install-profiles install-doc install-man

install-scripts:
	install -vDm 755 pawrchiso/mkpawrchiso -t "$(BIN_DIR)/"
	install -vDm 755 scripts/run_pawrchiso.sh "$(BIN_DIR)/run_pawrchiso"

install-profiles:
	install -d -m 755 $(PROFILE_DIR)
	cp -a --no-preserve=ownership configs $(PROFILE_DIR)/

install-doc:
	install -vDm 644 $(DOC_FILES) -t $(DOC_DIR)

install-man:
	@printf '.. |version| replace:: %s\n' '$(VERSION)' > man/version.rst
	install -d -m 755 $(MAN_DIR)/man1
	rst2man man/mkpawrchiso.1.rst $(MAN_DIR)/man1/mkpawrchiso.1

.PHONY: check install install-doc install-man install-profiles install-scripts shellcheck
