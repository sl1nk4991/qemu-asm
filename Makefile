all:
	as boot.s -o boot.o
	objcopy --remove-section .note.gnu.property boot.o
	ld boot.o -o boot.bin --oformat binary -Ttext 0x7c00
