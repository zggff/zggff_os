#ifndef __BOOT_DISK__
#define __BOOT_DISK__

#include "print.S"
#include "print_hex.S"

.code16
// load dh sectors from dl drive into location es:bx

load_disk:
    pusha

    // mov %ax, %bx


    mov $0x02, %ah  // read disk operation
    mov %dh, %al    // read dh secrots
    push %dx

    mov $0x00, %ch  // read from 0 cylinder
    mov $0x02, %cl  // read from 2 sector ( 1 - boot sector)
    mov $0x00, %dh  // read from 0 head
    // xor %bx, %bx
    // mov %bx, %es
    // mov %bx
    int $0x13
    jc .disk_error

    pop %dx
    cmp %dh, %al
    jne .disk_error2

    popa
    ret

.disk_error:
    mov $.disk_error_message, %si
    call print
    mov $0x0000, %dx
    mov %al, %dl
    call print_hex
    call print_new_line

.disk_error2:
    mov $.disk_error2_message, %si
    call print
    mov %al, %dl
    call print_hex
    call print_new_line




.disk_error_message: .asciz "Read disk error: "

.disk_error2_message: .asciz "Read disk error: wrong numbers of sectors read: "


#endif