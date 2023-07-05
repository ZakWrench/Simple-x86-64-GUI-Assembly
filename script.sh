#!/bin/bash

nasm -f elf64 -g main.nasm && ld main.o -static -o main

./main
echo $?

strace ./main
