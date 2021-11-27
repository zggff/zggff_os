#ifndef __BOOT_PRINT_PM
#define __BOOT_PRINT_PM

.code32

#define VIDEO_MEMORY 0xb8000
#define WHITE_ON_BLACK 0x0f

print_pm:
    pusha
    mov $VIDEO_MEMORY, %edx
    
.print_pm_start:
    lodsb
    mov $WHITE_ON_BLACK, %ah

    cmp $0, %al
    je .print_pm_end

    mov %ax, (%edx)
    add $0x2, %edx

    jmp .print_pm_start

.print_pm_end: 
    popa 
    ret

#endif