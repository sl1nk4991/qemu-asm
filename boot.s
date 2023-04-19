.code16
.globl _start
_start:
	mov $0x00, %ax
	int $0x10

	mov $msg, %si
	xor %dx, %dx
loop1:
	mov (%si), %al
	cmp $0x00, %al
	je end1
	mov $0x09, %ah
	mov $0x00, %bh
	mov $0x0f, %bl
	mov $0x01, %cx
	int $0x10
	inc %si
	mov $0x02, %ah
	inc %dl
	int $0x10
	jmp loop1

end1:
	mov %dl, var

loop2:
	mov $0x00, %ah
	int $0x16
	cmp $0x08, %al
	je delete
	cmp $0x1b, %al
	je finish
	mov $0x09, %ah
	int $0x10
	mov $0x02, %ah
	inc %dl
	int $0x10
	jmp loop2
delete:
	cmp var, %dl
	je loop2
	mov $0x02, %ah
	dec %dl
	int $0x10
	mov $0x09, %ah
	mov $0x20, %al
	int $0x10
	jmp loop2


finish:
	mov $0x5301, %ax
	xor %bx, %bx
	int $0x15
	mov $0x530e, %ax
	xor %bx, %bx
	mov $0x0102, %cx
	int $0x15
	mov $0x5307, %ax
	xor %bx, %bx
	inc %bx
	mov $0x0003, %cx
	int $0x15
	ret

var:
	.byte

msg:
	.ascii "input: "

_end:
	.fill 510-(.-_start), 1, 0
	.word 0xaa55
