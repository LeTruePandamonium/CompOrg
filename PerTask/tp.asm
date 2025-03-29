section .data
    msg1 db "Enter current weight (kg): ", 0
    msg2 db "Enter daily caloric intake (kcal): ", 0
    msg3 db "Enter number of months: ", 0
    result_msg db "Projected weight after ", 0
    months_msg db " months: ", 0
    newline db 10, 0
    kcal_per_kg dd 7700   ; 7,700 kcal = 1 kg

    input_fmt db "%d", 0
    output_fmt db "%d", 10, 0
    format_str db "%s", 0  ; Fix for string printing

section .bss
    weight resd 1
    calorie_intake resd 1
    months resd 1
    projected_weight resd 1

section .text
    global _start
    extern printf, scanf, exit  ; Use C exit to avoid syscall issues

_start:
    ; Ask for current weight
    mov rdi, format_str
    mov rsi, msg1
    xor rax, rax
    call printf
    mov rdi, input_fmt
    mov rsi, weight
    xor rax, rax
    call scanf

    ; Ask for daily caloric intake
    mov rdi, format_str
    mov rsi, msg2
    xor rax, rax
    call printf
    mov rdi, input_fmt
    mov rsi, calorie_intake
    xor rax, rax
    call scanf

    ; Ask for number of months
    mov rdi, format_str
    mov rsi, msg3
    xor rax, rax
    call printf
    mov rdi, input_fmt
    mov rsi, months
    xor rax, rax
    call scanf

    ; Compute projected weight
    mov eax, dword [calorie_intake]   ; Load daily intake (32-bit)
    imul eax, 30                      ; Multiply by 30 (monthly intake)
    cdq                               ; Sign-extend EAX into EDX:EAX
    idiv dword [kcal_per_kg]          ; Divide by 7700 to get kg change per month
    imul eax, dword [months]          ; Multiply by number of months
    add eax, dword [weight]           ; Add to initial weight
    mov dword [projected_weight], eax ; Store result

    ; Display result
    mov rdi, format_str
    mov rsi, result_msg
    xor rax, rax
    call printf

    mov rdi, output_fmt
    mov rsi, qword [months]
    xor rax, rax
    call printf

    mov rdi, format_str
    mov rsi, months_msg
    xor rax, rax
    call printf

    mov rdi, output_fmt
    movsx rsi, dword [projected_weight] ; Correct size for printf
    xor rax, rax
    call printf

    ; Print newline
    mov rdi, format_str
    mov rsi, newline
    xor rax, rax
    call printf

    ; Exit program
    xor rdi, rdi  ; Return 0
    call exit
