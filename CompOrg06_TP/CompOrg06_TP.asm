section .bss
    buffer resb 20        ; input buffer
    length resb 1
    number resd 1

section .text
    global _start

_start:
read_loop:
    ; Read input
    mov eax, 3           ; sys_read
    mov ebx, 0           ; stdin
    mov ecx, buffer
    mov edx, 20
    int 0x80

    ; Parse input string to integer
    mov esi, buffer
    xor eax, eax         ; EAX will hold the result
    xor ebx, ebx         ; EBX will be sign flag: 0=positive, 1=negative

    mov cl, [esi]
    cmp cl, '-'          ; check for negative sign
    jne parse_digits
    mov bl, 1            ; negative flag
    inc esi

parse_digits:
    xor ecx, ecx
.next_digit:
    mov cl, [esi]
    cmp cl, 10           ; newline?
    je done_parse
    cmp cl, 0
    je done_parse
    sub cl, '0'
    cmp cl, 9
    ja done_parse
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp .next_digit

done_parse:
    cmp bl, 0
    je store_num
    neg eax

store_num:
    mov [number], eax

    ; If number == 0, exit
    cmp eax, 0
    je exit

    ; Print binary label
    mov eax, 4
    mov ebx, 1
    mov ecx, binary_msg
    mov edx, binary_msg_len
    int 0x80

    ; Print binary
    mov eax, [number]
    mov ecx, 32          ; 32-bit output
    mov edi, binbuf

.print_loop:
    shl eax, 1
    jc .put1
    mov byte [edi], '0'
    jmp .next
.put1:
    mov byte [edi], '1'
.next:
    inc edi
    loop .print_loop

    ; Print binary string
    mov eax, 4
    mov ebx, 1
    mov ecx, binbuf
    mov edx, 32
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp read_loop

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

section .data
    binary_msg db 'Binary: ', 0xA
    binary_msg_len equ $ - binary_msg
    newline db 10
    binbuf times 32 db '0'
