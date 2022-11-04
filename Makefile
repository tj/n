PREFIX ?= /usr/local

install: bin/n
	mkdir -p "$(PREFIX)/bin"
	cp bin/n "$(PREFIX)/bin/n"

uninstall:
	rm -f "$(PREFIX)/bin/n"

.PHONY: install uninstall
