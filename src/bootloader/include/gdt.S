#ifndef __BOOT_GDT__
#define __BOOT_GDT__

.code16

.gdt_start:

.null_descriptor:
    .quad 0x0

.code_descriptor:
    .word 0xFFFF
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x00

.data_descriptor:
    .word 0xFFFF
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x00

.gdt_end:

gdt_descriptor:
    .word (.gdt_end - .gdt_start - 1)
    .long .gdt_start

#define CODE_SEG .code_descriptor - .gdt_start
#define DATA_SEG .data_descriptor - .gdt_start

#endif