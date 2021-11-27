#ifndef __BOOT_PRINT_HEX_PM__
#define __BOOT_PRINT_HEX_PM__


#include "print_pm.S"

.code32
// prints value stored in dx
print_hex_pm:
    pusha
    mov $0x00, %ecx
    // jmp .print_hex_end
.print_hex_pm_loop:
    cmp $0x04, %ecx
    // jmp .print_hex_p/m_end
    je .print_hex_pm_end
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
    mov $.print_hex_pm_pattern+5, %bx 
    sub %cx, %bx
    mov %al, (%bx)
    ror $0x04, %dx

    inc %cx
    jmp .print_hex_pm_loop

.print_hex_pm_end:
    mov $.print_hex_pm_pattern, %si
    call print_pm
    popa
    ret

.print_hex_pm_pattern: .asciz "0x0000"

#endif