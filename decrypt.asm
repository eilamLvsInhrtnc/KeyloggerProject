BITS 64

section .data
    file_name  db "C:\\keyLogProject\\decLog.txt",0
    file_input db "C:\\keyLogProject\\encLog.txt",0
    write_mode db "w", 0 
    read_mode  db "r", 0
    msg_open_fail db "bruh",10, 0


section .text
    global main
    extern fopen, getc, putc, exit , fclose , printf
    extern encrypt_and_put

main:
    sub rsp , 40

    lea rcx , [rel file_input]
    lea rdx , [rel read_mode]
    call fopen
    mov rsi , rax  ;encrypted file ptr 
    test rsi , rsi 
    jz .print_fail
    lea rcx , [rel file_name]
    lea rdx , [rel write_mode]
    call fopen
    mov rdi , rax ;decrypting file ptr
    test rdi , rdi
    jz .print_fail

.loop_start:
    mov rcx , rsi
    call getc
    cmp eax , -1
    je .file_close
    mov rcx , rax
    mov rdx , rdi
    call encrypt_and_put
    jmp .loop_start

.file_close:
    mov rcx , rsi
    call fclose
    mov rcx , rdi
    call fclose


.exit:
    add rsp, 40
    xor eax, eax
    call exit

.print_fail:
    lea rcx, [rel msg_open_fail]
    call printf
    jmp .exit