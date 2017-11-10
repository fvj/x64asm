section .text
global _start

_start:
	mov rax, 0x4
	mov rbx, count
	mov rcx, msg
	mov rdx, len
loop:
	push rbx
	mov rax, 0x4
	mov rbx, 0x1
	int 0x80
	pop rbx
	dec rbx
	jnz loop

	mov rax, 0x1
	mov rbx, 0x0
	int 0x80

section .data
	msg db "Hello, World", 0xa, 0
	len equ $ - msg
	count equ 100
