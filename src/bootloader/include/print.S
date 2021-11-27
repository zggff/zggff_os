#ifndef __BOOT_PRINT__
#define __BOOT_PRINT__

.code16

print:
    pusha

.print_start:
    xorb %bh, %bh
    movb $0x0E, %ah
    lodsb

    cmpb $0, %al
    je .print_end

    int $0x10
    jmp .print_start

.print_end: 
    popa 
    ret

print_new_line:
    pusha
    mov $.print_new_line_chars, %si
    call print
    popa
    ret
    
.print_new_line_chars: .asciz "\n\r"

#endif
