N_PREFIX ?= /usr/local

install: bin/n
	cp $< $(N_PREFIX)/$<

uninstall:
	rm -f $(N_PREFIX)/bin/n

.PHONY: install uninstall