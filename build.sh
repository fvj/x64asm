#!/bin/bash

if [ "$#" -eq 0 ]; then
	echo "you must provide the name of your program"
	exit 1
fi

nasm -f elf64 -o "$1.o" "$1.asm" && ld "$1.o" -o "$1"
