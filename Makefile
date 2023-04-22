all:
	as boot.s -o boot.o
	objcopy boot.o --remove-section .note.gnu.property
	ld boot.o -o boot.bin --oformat binary -Ttext 0x7c00 -e 0
	gcc codeinc.c -o codeinc

clean:
	rm -f boot.bin boot.o codeinc
