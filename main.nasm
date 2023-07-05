BITS 64 
CPU X64 ; Target x86_64 family of CPUs.

section .rodata

sun_path: db "/tmp/.X11-unix/X0", 0



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

; Create a UNIX domain socket and connect to the X11 server.
; @returns The socket file descriptor.
x11_connect_to_server:
static x11_connect_to_server:function
  push rbp
  mov rbp, rsp 

  ; Open a Unix socket: socket(2).
  mov rax, SYSCALL_SOCKET
  mov rdi, AF_UNIX ; Unix socket.
  mov rsi, SOCK_STREAM ; Stream oriented.
  mov rdx, 0 ; Automatic protocol.
  syscall

  cmp rax, 0
  jle die

  mov rdi, rax ; Store socket fd in `rdi` for the remainder of the function.

  sub rsp, 112 ; Store struct sockaddr_un on the stack.

  mov WORD [rsp], AF_UNIX ; Set sockaddr_un.sun_family to AF_UNIX
  ; Fill sockaddr_un.sun_path with: "/tmp/.X11-unix/X0".
  lea rsi, sun_path
  mov r12, rdi ; Save the socket file descriptor in `rdi` in `r12`.
  lea rdi, [rsp + 2]
  cld ; Move forward
  mov ecx, 19 ; Length is 19 with the null terminator.
  rep movsb ; Copy.

  ; Connect to the server: connect(2).
  mov rax, SYSCALL_CONNECT
  mov rdi, r12
  lea rsi, [rsp]
  %define SIZEOF_SOCKADDR_UN 2+108
  mov rdx, SIZEOF_SOCKADDR_UN
  syscall

  cmp rax, 0
  jne die

  mov rax, rdi ; Return the socket fd.

  add rsp, 112
  pop rbp
  ret




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

global _start

_start:
	xor rax, rax            ; Clear rax

	

	mov rax, SYSCALL_EXIT    ; Set up the exit system call number in rax
	mov rdi, 0              ; Set up the exit status in rdi
	syscall                 ; Call the system call to exit
	
