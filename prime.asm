section .text
global _start

prime:
	cmp rbx, 0x1
	ja maybeprime_
notprime_:
	xor rax, rax
	ret
maybeprime_:
	mov rcx, 0x2
loop:
	mov rax, rcx
	mul rax
	cmp rax, rbx
	jge isprime
	mov rax, rbx
	div rcx
	cmp rdx, 0
	je notprime_
	inc rcx
	jmp loop
isprime:
	mov rax, 0x1
	ret

_start:
	mov rbx, number
	call prime

	mov rbx, 0x1
	cmp rax, 0x0
	jne pprimemsg
	mov rax, 0x4
	mov rcx, notprimemsg
	mov rdx, notprimelen
	int 0x80
	jmp exit

pprimemsg:
	mov rax, 0x4
	mov rcx, primemsg
	mov rdx, primelen
	int 0x80

exit:
	mov rax, 0x1
	xor rbx, rbx
	int 0x80

section .data
	primemsg db ":)", 0xa, 0x0
	primelen equ $ - primemsg
	notprimemsg db ":(", 0xa, 0x0
	notprimelen equ $ - primemsg
	number equ 9223372036854775807
