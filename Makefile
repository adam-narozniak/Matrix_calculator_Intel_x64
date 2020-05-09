CC = g++
CFLAGS = -Wall -m64

all: main.o mc.o
	$(CC) $(CFLAGS) main.o mc.o -o fun

#asm: main.o mc.o
#	$(CC) $(CFLAGS) -o fun main.o mc.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o 

mc.o: mc.s
	nasm -f elf64 mc.s -o mc.o 

clean:
	rm -f *.o

run: fun
	./fun

