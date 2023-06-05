BITS 64
CPU X64

%define SYSCALL_WRITE 1
%define STDOUT 1
%define SYSCALL_EXIT 60
section .text
global _start

print_hello:
	push rbp
	mov rbp, rsp
	
	sub rsp, 5
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
  
  add rsp, 5
  
  pop rbp
  ret
_start:
	xor rax, rax
	
	mov rax, SYSCALL_EXIT
	mov rdi, 0
	syscall
