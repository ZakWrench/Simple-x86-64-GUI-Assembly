#!/bin/bash

./main
echo $?

strace ./main
