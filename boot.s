.code16
.text
	.globl init
init:
	xor %ax, %ax
	mov %ax, %bx
	mov %ax, %es
	mov %ax, %ds
	mov %ax, %ss
	mov 0x7000, %sp
	jmp _start

disp:
	push %ax
	push %bx
	mov $0x0001, %ax
	int $0x10
	mov $0x0001, %bx
	mov $0x0b, %ah
	int $0x10
	pop %bx
	pop %ax
	ret

print:
	push %ax
	push %bx
	push %si
	print_loop:
		mov (%si), %al
		cmp $0x00, %al
		je print_ret
		mov $0x0e, %ah
		int $0x10
		inc %si
		jmp print_loop
	print_ret:
		pop %si
		pop %bx
		pop %ax
		ret

input:
	push %ax
	push %bx
	push %si
	input_loop:
		mov $0x0000, %ax
		int $0x16
		mov $0x0e, %ah
		cmp $0x0d, %al
		je input_ret
		cmp $0x08, %al
		je input_delete
		cmp $0x20, %al
		jl input_loop
		cmp $0x7e, %al
		jg input_loop
		mov %al, (%si)
		inc %si
		inc %di
		int $0x10
		jmp input_loop
	input_delete:
		mov $0x03, %ah
		int $0x10
		cmp $msgl, %dx
		jl input_loop
		dec %si
		dec %di
		movb $0x00, (%si)
		mov $0x0e08, %ax
		int $0x10
		mov $0x0a20, %ax
		mov $0x01, %cx
		int $0x10
		jmp input_loop
	input_ret:
		movw $0x0d0a, (%si)
		mov $0x0d, %al
		int $0x10
		mov $0x0a, %al
		int $0x10
		pop %si
		pop %bx
		pop %ax
		ret

clear:
	push %si
	push %di
	clear_loop:
		cmpb $0x00, (%si)
		je clear_ret
		movb $0x00, (%si)
		dec %di
		inc %si
		jmp clear_loop
	clear_ret:
		pop %di
		pop %si
		ret

_start:
	call disp
	loop:
		mov $msg, %si
		call print
		mov $inp, %si
		mov $0x00, %di
		call input
		call print
		call clear
		jmp loop

msg: .ascii "input> \0"
msgl = .-msg
inp: .byte

.fill 510-(.-init), 1, 0
.word 0xaa55
