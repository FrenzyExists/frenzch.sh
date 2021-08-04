PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man

all:
	@echo Run \'make install\' to install Frenzch.

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p frenzch.sh $(DESTDIR)$(PREFIX)/bin/frenzch
	@cp -p frenzch.1 $(DESTDIR)$(MANDIR)/man1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/frenzch

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/frenzch.sh
	@rm -rf $(DESTDIR)$(MANDIR)/man1/frenzch.1*

