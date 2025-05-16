# HW11 
once code has been downloaded, in the gl environment run the following commands to produce the ASCII representations of the input hex values:
nasm -f elf32 -g -F dwarf -o hw11.o hw11.asm
 ld -m elf_i386 -o hw11 hw11.o
 ./hw11
