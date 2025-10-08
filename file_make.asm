BITS 64

section .data
    write_mode  db "w", 0 
    file_name db "C:\\keyLogProject\\encLog.txt",0
    
section .text
    global file_make
    extern fopen

file_make:
    sub rsp, 40
    lea rcx, [rel file_name]
    lea rdx, [rel write_mode]
    call fopen
    add rsp, 40
    ret