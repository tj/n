
PREFIX ?= /usr/local

install: bin/n
	cp $< $(PREFIX)/$<

uninstall:
	rm -f $(PREFIX)/n

.PHONY: install uninstall