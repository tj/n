PREFIX ?= /usr/local

install: bin/n
	mkdir -p $(PREFIX)/$(dir $<)
	cp $< $(PREFIX)/$<

uninstall:
	rm -f $(PREFIX)/bin/n

.PHONY: install uninstall
