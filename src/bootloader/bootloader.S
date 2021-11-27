.code16

#define STACK_OFFSET 0x3000
#define KERNEL_OFFSET 0x1000

.section .text
.global _start
_start:
    // ljmp $0x07C0, $_start1
    jmp _start1
    
#include "include/print.S"
#include "include/print_hex.S"
#include "include/disk.S"
#include "include/gdt.S"
#include "include/switch_to_pm.S"
#include "include/print_pm.S"
#include "include/print_hex_pm.S"


.code16

_start1:
    // movw %cs, %ax           // set offset registers
    // movw %ax, %es
    // movw %ax, %ds
    // movw %ax, %es
    // movw %ax, %ss
    movw STACK_OFFSET, %bp  // set stack
    movw STACK_OFFSET, %sp

    movb %dl, boot_drive    // store boot drive in memory


    movb $0x20, %dh
    movw $KERNEL_OFFSET, %bx
    call load_disk

    call switch_to_pm

    jmp .

.code32

// .globl main
begin_pm:
    // mov 0x01f0, %dx
    // call print_hex_pm
    call KERNEL_OFFSET
    // call print_pm


    jmp .

    

hello_rm: .asciz "HELLO RM"
hello_pm: .asciz "HELLO PM"
boot_drive: .byte 0
// value: .word (.code_descriptor - .gdt_start)


.fill 510-(.-_start),1,0
.word 0xAA55


