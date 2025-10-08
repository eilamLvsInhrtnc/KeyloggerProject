BITS 64
    
section .bss
    input_char_str  resb 2 ; str to store the char scanned for strcat usage.

section .text
    global encrypt_and_put
    extern fputs

encrypt_and_put: ;(char c , FILE* fp) ---> rcx = c rdx = fp
    push rbx
    sub rsp, 40 ; shadow space, windows convention.
    mov rbx, rdx      ; save FILE* in rbx

    xor cl , 217 ; random number for xor encryption.
    mov byte [rel input_char_str] , cl
    mov byte [rel input_char_str + 1] , 0

    lea rcx , [rel input_char_str]
    mov rdx , rbx
    call fputs

    add rsp , 40
    pop rbx
    ret