
PREFIX ?= /usr/local

install: bin/n
	cp $< $(PREFIX)/$<

link: bin/n
	ln -s $(CURDIR)/$< $(PREFIX)/$<

uninstall:
	rm -f $(PREFIX)/bin/n

.PHONY: install link uninstall
