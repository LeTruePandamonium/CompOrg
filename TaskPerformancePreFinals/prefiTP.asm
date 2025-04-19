section .data
    prompt_msg     db 'Enter a single-digit number: ', 0Ah
    prompt_len     equ $ - prompt_msg

    below_msg_str  db 0Dh, 0Ah, 'input is < 5', 0Ah
    below_len      equ $ - below_msg_str

    equal_msg_str  db 0Dh, 0Ah, 'input is = 5', 0Ah
    equal_len      equ $ - equal_msg_str

    above_msg_str  db 0Dh, 0Ah, 'input is > 5', 0Ah
    above_len      equ $ - above_msg_str

    input          db 0, 0         ; room for char + newline

section .text
    global _start

_start:
    call get_input
    call compare_to_5
    jmp exit

get_input:
    ; Display prompt
    mov eax, 4         ; sys_write
    mov ebx, 1         ; stdout
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 80h

    ; Read input
    mov eax, 3         ; sys_read
    mov ebx, 0         ; stdin
    mov ecx, input
    mov edx, 2         ; read 1 char + newline
    int 80h

    ; Convert ASCII to integer (ignore newline at input[1])
    sub byte [input], '0'
    ret

compare_to_5:
    mov al, [input]
    cmp al, 5

    jb .below
    je .equal
    ja .above

.below:
    mov eax, 4
    mov ebx, 1
    mov ecx, below_msg_str
    mov edx, below_len
    int 80h
    ret

.equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, equal_msg_str
    mov edx, equal_len
    int 80h
    ret

.above:
    mov eax, 4
    mov ebx, 1
    mov ecx, above_msg_str
    mov edx, above_len
    int 80h
    ret

exit:
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; status = 0
    int 80h
