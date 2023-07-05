BITS 64 
CPU X64 ; Target x86_64 family of CPUs.
; System V ABI 
; 1 is the value of write() system call, STDOUT is also set to 1, exit() sys call has 60.
; %define define constants.
%define SYSCALL_WRITE 1     ; Define constant for write system call
%define STDOUT 1            ; Define constant for standard output file descriptor
%define SYSCALL_EXIT 60     ; Define constant for exit system call

section .text ; This tells `nasm` and the linker, that what follows is code that should be placed in the text section of the executable.
global _start

print_hello:
	push rbp                ; Save base pointer on the stack, to be able to restore it at the end of the function
	mov rbp, rsp            ; Set up new base pointer, set rbp to rsp 

	sub rsp, 3             ; Allocate space on the stack for the string "zak"

	mov BYTE [rsp + 0], 'z' ; Store 'z' in the first byte of the string
	mov BYTE [rsp + 1], 'a' ; Store 'a' in the second byte of the string
	mov BYTE [rsp + 2], 'k' ; Store 'k' in the third byte of the string
	
	; Make the write syscall
	mov rax, SYSCALL_WRITE   ; Set up the write system call number in rax
	mov rdi, STDOUT         ; Set up the standard output file descriptor in rdi
	lea rsi, [rsp]          ; Set up the address of the string in rsi
	mov rdx, 3              ; Set up the length of the string in rdx
	syscall                 ; Call the system call to write the string

	add rsp, 3              ; Deallocate the stack space used for the string

	pop rbp                 ; Restore the previous base pointer
	ret                     ; Return from the subroutine

_start:
	xor rax, rax            ; Clear rax

	mov rax, SYSCALL_EXIT    ; Set up the exit system call number in rax
	mov rdi, 0              ; Set up the exit status in rdi
	syscall                 ; Call the system call to exit
