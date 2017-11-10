section .text
global _start

%macro puts 2
	mov rax, 0x4
	mov rbx, 0x1
	mov rcx, %1
	mov rdx, %2
	int 0x80
%endmacro

%macro gets 2
	mov rcx, %1
	mov rdx, %2
	mov rax, 0x3
	xor rbx, rbx
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

rot13:
	mov rdx, rax
	call strlen
	mov rbx, rax
	dec rbx
	mov rcx, 0x0
	rot13loop:
		xor rax, rax
		mov al, byte [rdx]	
		sub rax, 52
		push rdx
		xor rdx, rdx
		mov r8, 26
		div r8
		mov rax, rdx
		add rax, 65
		pop rdx
		mov byte [rdx], al 
		cmp rcx, rbx
		je rot13done
		inc rcx
		inc rdx
		jmp rot13loop

	rot13done:
		mov rax, 0x0
		ret

_start:
	gets buffer, 127
	mov rax, buffer
	call rot13
	puts buffer, 127

	exit 0
	
section .bss
	buffer: resb 128
