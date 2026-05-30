CC = gcc
CFLAGS = -O3 -march=native -Wall -Wextra

TARGET = ../scripts/.local/bin/audiograph
SRC = src/audiograph.c

all:
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) -lm

clean:
	rm -f $(TARGET)
