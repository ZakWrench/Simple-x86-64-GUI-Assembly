#!/bin/bash

nasm -f elf64 -g main.nasm && ld main.o -static -o main

./main
echo $?

strace ./main

readelf -a ./main #this tells us that the `.text` section, which contains our code, is only * bytes long.


