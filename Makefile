CC = gcc 
CFLAGS = -Wall -m64 -g 

all: main.o mc.o
	$(CC) $(CFLAGS) main.o mc.o -o fun

#asm: main.o mc.o
#	$(CC) $(CFLAGS) -o fun main.o mc.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

mc.o: mc.asm
	nasm -f elf64 mc.asm -o mc.o 

clean:
	rm -f *.o

run: fun
	./fun
#gdb fun

