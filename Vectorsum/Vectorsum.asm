section .data

        msg db "The vector sum result is: ",32
        len equ $ - msg

        v1 dd 2.75, 4.0, 6.0, 8.0
        v2 dd 1.25, 3.0, 5.0, 7.0
        result dd 0.0, 0.0, 0.0, 0.0

        precision dd 10000.0

        comma db '.'
        comma_len equ $ - comma

        index dq 0
        loop_counter dq 4

section .bss
        decimal resb 8
        fractional resb 8

        decimal_ascii_buffer resb 8
        fractional_ascii_buffer resb 8

        decimal_ascii_result resb 8
        decimal_len resb 8
        
        fractional_ascii_result resb 8
        fractional_len resb 8


section .text
    
    global _start

_start:
        movups xmm0,[v1]
        movups xmm1,[v2]
        jmp addition

addition:
        addps xmm0,xmm1
        movups [result],xmm0
        jmp print_prompt


 print_prompt:       
        mov rax,1
        mov rdi,1
        mov rsi,msg
        mov rdx,len
        syscall
        jmp convert_result_to_ascii       

convert_result_to_ascii:
        .load:
                cmp qword [loop_counter],0
                je exit
                mov rsi,result
                add rsi,[index]
                mov rbx,decimal
                mov rcx,fractional
                jmp .extract

        .extract:
                mov rax,0
                movss xmm0,[rsi]
                cvtss2si rax,xmm0
                mov [rbx],rax
                cvtsi2ss xmm1,rax
                subss xmm0,xmm1
                mulss xmm0,[precision]
                cvtss2si rax,xmm0
                mov [rcx],rax
                jmp .reload2
        

        .reload2:
                mov rax,[decimal]
                mov rsi,decimal_ascii_buffer
                mov rbx,0
                mov rcx,10
                jmp .convert_decimal_to_ascii

        
        .convert_decimal_to_ascii:
                mov rdx,0
                div rcx
                add dl,'0'
                mov [rsi],dl
                inc rbx
                cmp rax,0
                je .decimal_ascii_storage
                inc rsi
                jmp .convert_decimal_to_ascii
        
        
        .decimal_ascii_storage:
                mov rdx,decimal_len
                mov [rdx],rbx
                mov rcx,decimal_ascii_result
                jmp .reverse_decimal_ascii

        
        .reverse_decimal_ascii:
                mov rax,0
                cmp rbx,0
                je .reload3
                mov al,[rsi]
                mov [rcx],al
                dec rsi
                dec rbx
                inc rcx
                jmp .reverse_decimal_ascii


        .reload3:
                mov rax,[fractional]
                mov rsi,fractional_ascii_buffer
                mov rbx,0
                mov rdx,0
                mov rcx,10
                jmp .convert_fractional_to_ascii


        .convert_fractional_to_ascii:
                mov rdx,0
                div rcx
                add dl,'0'
                mov [rsi],dl
                inc rbx
                cmp rax,0
                je .fractional_storage
                inc rsi
                jmp .convert_fractional_to_ascii



        .fractional_storage:
                mov rdx,fractional_len
                mov [rdx],rbx
                mov rcx,fractional_ascii_result
                jmp .reverse_fractional_ascii


        .reverse_fractional_ascii:
                mov rax,0
                cmp rbx,0
                je .space
                mov al,[rsi]
                mov [rcx],al
                dec rbx
                dec rsi
                inc rcx
                jmp .reverse_fractional_ascii
        
        .space:
                cmp qword [loop_counter],1
                je .newline
                mov byte [rcx],32
                inc byte [rdx]
                jmp .print_result
        
        .newline:
                mov byte [rcx],10
                inc byte [rdx]
                jmp .print_result


        .print_result:
                mov rax,1
                mov rdi,1
                mov rsi,decimal_ascii_result
                mov rdx,[decimal_len]
                syscall

                mov rax,1
                mov rdi,1
                mov rsi,comma
                mov rdx,comma_len
                syscall

                mov rax,1
                mov rdi,1
                mov rsi,fractional_ascii_result
                mov rdx,[fractional_len]
                syscall
                jmp .update_counter
        
        .update_counter:
                dec qword [loop_counter]
                mov rax,[index]
                add rax,4
                mov [index],rax
                jmp .load



exit:        
        mov rax,60
        mov rdi,rax
        syscall