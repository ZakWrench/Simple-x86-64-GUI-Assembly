BITS 64 
CPU X64 ; Target x86_64 family of CPUs.

section .rodata

section .data



section .text ; This tells `nasm` and the linker, that what follows is code that should be placed in the text section of the executable.

; System V ABI 

%define AF_UNIX 1
%define SOCK_STREAM 1

%define SYSCALL_SOCKET 41
%define SYSCALL_EXIT 60

; 1 is the value of write() system call, STDOUT is also set to 1, exit() sys call has 60.
; %define define constants.
%define SYSCALL_WRITE 1     ; Define constant for write system call
%define STDOUT 1            ; Define constant for standard output file descriptor
%define SYSCALL_EXIT 60     ; Define constant for exit system call

global _start

print_zak:
	push rbp                ; Save base pointer on the stack, to be able to restore it at the end of the function
	mov rbp, rsp            ; Set up new base pointer, set rbp to rsp 

	sub rsp, 16             ; Allocate space on the stack for the string "zak"

	mov BYTE [rsp + 0], ' ' ; Store 'z' in the first byte of the string
	mov BYTE [rsp + 1], 'z' ; Store 'a' in the second byte of the string
	mov BYTE [rsp + 2], 'a' ; Store 'k' in the third byte of the string
	mov BYTE [rsp + 3], 'k'
	; Make the write syscall
	mov rax, SYSCALL_WRITE   ; Set up the write system call number in rax
	mov rdi, STDOUT         ; Set up the standard output file descriptor in rdi
	lea rsi, [rsp]          ; Set up the address of the string in rsi
	mov rdx, 4              ; Set up the length of the string in rdx
	syscall                 ; Call the system call to write the string

	add rsp, 16              ; Deallocate the stack space used for the string

	pop rbp                 ; Restore the previous base pointer
	ret                     ; Return from the subroutine


print_hello:
	push rbp
	mov rbp, rsp

	sub rsp, 16
	mov BYTE [rsp + 0], 'h'
	mov BYTE [rsp + 1], 'e'
	mov BYTE [rsp + 2], 'l'
	mov BYTE [rsp + 3], 'l'
	mov BYTE [rsp + 4], 'o'

	mov rax, SYSCALL_WRITE
	mov rdi, STDOUT
	lea rsi, [rsp]
	mov rdx, 5
	syscall

	call print_zak

	add rsp, 16
	
	pop rbp
	ret


_start:
	xor rax, rax            ; Clear rax

	; open a unix socket
	mov rax, SYSCALL_SOCKET
	mov rdi, AF_UNIX; Unix socket
	mov rsi, SOCK_STREAM; Stream oriented
	mov rdx, 0; automatic protocol
	syscall

	mov rax, SYSCALL_EXIT    ; Set up the exit system call number in rax
	mov rdi, 0              ; Set up the exit status in rdi
	syscall                 ; Call the system call to exit
	
