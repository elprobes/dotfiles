CC=gcc

CFLAGS=-O2 -Wall -Wextra -Wpedantic -Wconversion

TARGET=netgraph

$(TARGET): netgraph.c
	$(CC) $(CFLAGS) netgraph.c -lm -o $(TARGET)

install: $(TARGET)
	install -Dm755 $(TARGET) $(HOME)/.local/bin/$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: install clean
