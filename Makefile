PREFIX ?= /usr/local

install: bin/n
	mkdir -p $(PREFIX)/$(dir bin/n)
	cp bin/n $(PREFIX)/bin/n

uninstall:
	rm -f $(PREFIX)/bin/n

.PHONY: install uninstall
