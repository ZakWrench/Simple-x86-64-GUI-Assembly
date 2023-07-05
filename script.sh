#!/bin/bash

#Deactivate the red zone which is a 128 byte region at the bottom of the stack.
nasm -f elf64 -g main.nasm && cc main.o -static -o main -mno-red-zone -nostdlib. 
#Assemble main.nasm to create object file, then link it statically to create executable 'main'
nasm -f elf64 -g main.nasm && ld main.o -static -o main

./main
echo $?

strace ./main

readelf -a ./main #this tells us that the `.text` section, which contains our code, is only * bytes long.


