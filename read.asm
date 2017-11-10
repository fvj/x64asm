section .text
global _start

%macro gets 2
	mov rax, 0x3
	xor rbx, rbx
	mov rcx, %1
	mov rdx, %2
	int 0x80
%endmacro

%macro puts 2
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, %1
	mov rdx, %2
	int 0x80
%endmacro

%macro exit 1
	mov rbx, %1
	mov rax, 0x1
	int 0x80
%endmacro

strlen:
	mov rcx, 0
	loop:
		cmp byte [rax], 0x0
		je done
		inc rax
		inc rcx
		jmp loop
	done:
		dec rcx
		mov rax, rcx
		ret
	
max:
	cmp rax, rbx
	jle second
	ret
	second:
		mov rax, rbx
		ret
	
checkkey:
	mov rax, buffer
	call strlen
	mov rbx, rax
	mov rax, key
	call strlen
	call max
	mov rdx, rax
	cmp rax, rbx
	jne notequal
	mov rax, buffer
	mov rbx, key
	mov rcx, 0
	checkloop:
		push rax
		mov rax, [rax]
		cmp [rbx], rax
		pop rax
		jne notequal
		cmp rdx, rcx
		je equal
		inc rax
		inc rbx
		inc rcx
		jmp checkloop
	notequal:
		mov rax, 0x1
		ret
	equal:
		mov rax, 0x0
		ret

_start:
	puts entermsg, enterlength
	gets buffer, 64
	call checkkey
	cmp rax, 0x0
	jne failure
	puts winmsg, winlen
	exit 0x0

failure:
	puts losemsg, loselen
	exit 0x1

section .data
	winmsg db "ACCESS GRANTED", 0xa, 0x0
	winlen equ $ - winmsg
	losemsg db "ACCESS DENIED", 0xa, 0x0
	loselen equ $ - losemsg
	entermsg db "password: ", 0x0
	enterlength equ $ - entermsg
	key db 'HELLO', 0xa, 0x0

section .bss
	buffer: resb 64
