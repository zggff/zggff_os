#ifndef __BOOT_PRINT_HEX__
#define __BOOT_PRINT_HEX__

.code16

#include "print.S"

// prints value stored in dx
print_hex:
    pusha
    mov $0x00, %cx
    // jmp .print_hex_end
.print_hex_loop:
    cmp $0x04, %cx
    je .print_hex_end
    mov %dx, %ax
    and $0x000F, %ax
    cmp $0x09, %al
    jle 1f   
    jmp 2f

1:
    add $0x30, %al
    jmp 3f
2:
    add $0x37, %al
    jmp 3f
3:
    mov $.print_hex_pattern+5, %bx 
    sub %cx, %bx
    mov %al, (%bx)
    ror $0x04, %dx

    inc %cx
    jmp .print_hex_loop

.print_hex_end:
    mov $.print_hex_pattern, %si
    call print
    popa
    ret

.print_hex_pattern: .asciz "0x0000"

#endif