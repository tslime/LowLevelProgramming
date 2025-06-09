section .data
        msg1 db "Enter your first number: ",32
        len1 equ $ - msg1

        msg2 db "Enter your second number: ",32
        len2 equ $ - msg2

        msg3 db "Press the number corresponding to the operation you would like to execute: 1.addition, 2.subtraction, 3.multiplication, 4.division: ",32
        len3 equ $ - msg3

        msg4 db "The result of your arithmetic operation is: ",32
        len4 equ $ - msg4

        msg db "message: ",32
        len equ $ - msg

        minus_char db '-'


section .bss
        input1 resb 8
        input2 resb 8
        arithmetic_operation resb 8

        buffer1 resb 8
        buffer2 resb 8
        buffer3 resb 8
        
        sign_holder resb 8

section .text
        global _start

_start:
        mov rax,1
        mov rdi,1
        mov rsi,msg1
        mov rdx,len1
        syscall

       
        mov rax,0
        mov rdi,0
        mov rsi,input1
        mov rdx,32
        syscall
        jmp verify_sign1


verify_sign1:
        mov al,[rsi]
        cmp al,'-'
        je mark_sign1
        jmp reload1

mark_sign1:
        mov byte [sign_holder],'-'
        inc rsi
        jmp reload1


reload1:
        mov rbx,buffer1
        mov qword [rbx],0
        jmp convert1 

convert1:
        mov al,[rsi]
        cmp al,10
        je negative_conversion1
        sub al,'0'
        movzx rcx,al
        imul rax, qword [rbx],10
        add rax,rcx
        mov [rbx],rax
        inc rsi
        jmp convert1

negative_conversion1:
        cmp byte [sign_holder],'-'
        jne second_input
        neg qword [buffer1]
        jmp second_input


second_input:
        mov rax,1
        mov rdi,1
        mov rsi,msg2
        mov rdx,len2
        syscall

        mov rax,0
        mov rdi,0
        mov rsi,input2
        mov rdx,32
        syscall
        jmp verify_sign2

verify_sign2:
        mov byte [sign_holder],0
        mov al,[rsi]
        cmp al,'-'
        je mark_sign2
        jmp reload2

mark_sign2:
        mov byte [sign_holder],'-'
        inc rsi
        jmp reload2


reload2:
        mov rbx,buffer2
        mov qword [rbx],0
        jmp convert2

convert2:
        mov al,[rsi]
        cmp al,10
        je negative_conversion2
        sub al,'0'
        movzx rcx,al
        imul rax, qword [rbx],10
        add rax,rcx
        mov [rbx],rax
        inc rsi
        jmp convert2

negative_conversion2:
        cmp byte [sign_holder],'-'
        jne a_operation
        neg qword [buffer2]
        jmp a_operation


a_operation:
        mov rax,1
        mov rdi,1
        mov rsi,msg3
        mov rdx,len3
        syscall

        mov rax,0
        mov rdi,0
        mov rsi,arithmetic_operation
        mov rdx,8
        syscall

        mov rsi,arithmetic_operation
        cmp byte [rsi],'1'
        je addition
        cmp byte [rsi],'2'
        je subtraction
        cmp byte [rsi],'3'
        je multiplication
        cmp byte [rsi],'4'
        je division

addition:
        mov rbx,[buffer1]
        add rbx,[buffer2]
        mov rax,rbx
        mov rbx,0
        jmp sign_check

subtraction:
        mov rbx,[buffer1]
        sub rbx,[buffer2]
        mov rax,rbx
        mov rbx,0
        jmp sign_check

multiplication:
        mov rbx,[buffer1]
        imul rbx,[buffer2]
        mov rax,rbx
        mov rbx,0
        jmp sign_check

division:
        mov rax,[buffer1]
        mov rcx,[buffer2]
        mov rdx,0
        mov rbx,0
        cqo
        idiv rcx
        jmp sign_check

sign_check:
        test rax,rax
        js complement
        jmp convert


complement:
        neg rax
        mov byte [sign_holder],'-'
        jmp convert

convert:
        mov rdx,0
        mov rcx,10
        div rcx
        add dl,'0'
        mov [rsi],dl
        inc rbx
        cmp rax,0
        je result_storage
        inc rsi
        jmp convert

result_storage: 
        mov rdx,0
        mov rcx,buffer3
        jmp reverse

reverse:
        cmp rbx,0
        je sign_verification
        mov al,[rsi]
        mov [rcx],al
        dec rbx
        dec rsi
        inc rcx
        inc rdx
        jmp reverse



sign_verification:
        cmp byte [sign_holder],'-'
        je signed_result
        jmp non_signed_result




non_signed_result: 
        mov byte [rcx],10
        inc rdx
        mov rbx,rdx
        mov rax,1
        mov rdi,1
        mov rsi,msg4
        mov rdx,len4
        syscall
        
        mov rax,1
        mov rdi,1
        mov rsi,buffer3
        mov rdx,rbx
        syscall

        mov rax,60
        mov rdi,rax
        syscall

signed_result: 
        mov byte [rcx],10
        inc rdx
        mov rbx,rdx
        mov rax,1
        mov rdi,1
        mov rsi,msg4
        mov rdx,len4
        syscall

        mov rax,1
        mov rdi,1
        mov rsi,sign_holder
        mov rdx,1
        syscall
        
        mov rax,1
        mov rdi,1
        mov rsi,buffer3
        mov rdx,rbx
        syscall

        mov rax,60
        mov rdi,rax
        syscall