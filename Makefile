PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man

all:
	@echo Run \'make install\' to install Frenzch.
	@sleep 1
	@echo Also... Bleach is better than One Piece, and Fairytail, now suffer

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(MANDIR)/man1
	@cp -p frenzch.sh $(DESTDIR)$(PREFIX)/bin/frenzch.sh
	@cp -p frenzch.1 $(DESTDIR)$(MANDIR)/man1
	@cp -p info.sh $(DESTDIR)$(PREFIX)/bin/info.sh
	@cp -p bash_jesus.sh $(DESTDIR)$(PREFIX)/bin/bash_jesus.sh
	@cp -p boi $(DESTDIR)$(PREFIX)/bin/boi
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/frenzch.sh
uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/frenzch.sh
	@rm -rf $(DESTDIR)$(MANDIR)/man1/frenzch.1*

