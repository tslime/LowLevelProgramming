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
        sign_len equ $ - minus_char

        comma db '.'
        comma_len equ $ - comma

        negative dq -1.0

        precision dq 1000.0

section .bss
        input1 resb 8
        input2 resb 8
        arithmetic_operation resb 8

        decimal_buffer1 resb 8
        fractional_buffer1 resb 8
        converted_input1 resb 8

        decimal_buffer2 resb 8
        fractional_buffer2 resb 8
        converted_input2 resb 8
        
        sign_flag resb 8

        result_decimal_buffer resb 8
        result_fractional_buffer resb 8

        decimal_ascii_buffer resb 8
        fractional_ascii_buffer resb 8

        result_decimal_ascii resb 8
        decimal_length resb 8

        result_fractional_ascii resb 8
        fractional_length resb 8

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
        jne reload1
        mov rax,sign_flag
        mov byte [rax],1
        inc rsi
        jmp reload1

        
reload1:
        mov rbx,decimal_buffer1
        mov qword [rbx],0
        jmp convert_decimal1 


convert_decimal1:
        mov rax,0
        mov al,[rsi]
        cmp al,10
        je int_to_float_conversion1
        cmp al,'.'
        je reload2
        sub al,'0'
        movzx rcx,al
        imul rax,[rbx],10
        add rax,rcx
        mov [rbx],rax
        inc rsi
        jmp convert_decimal1


reload2:
        mov rbx,fractional_buffer1
        mov qword [rbx],0
        mov rdx,1
        inc rsi
        jmp convert_fractional1


convert_fractional1:
        mov rax,0
        mov al,[rsi]
        cmp al,10
        je float_conversion1
        sub al,'0'
        movzx rcx,al
        imul rax,[rbx],10
        add rax,rcx
        mov [rbx],rax
        imul rdx,rdx,10
        inc rsi
        jmp convert_fractional1


int_to_float_conversion1:
        cvtsi2sd xmm0,[decimal_buffer1]
        cmp byte [sign_flag],1
        jne store_converted1
        mulsd xmm0,[negative]
        jmp store_converted1



float_conversion1:
        cvtsi2sd xmm0,[decimal_buffer1]
        cvtsi2sd xmm1,[fractional_buffer1]
        cvtsi2sd xmm2,rdx
        divsd xmm1,xmm2
        addsd xmm0,xmm1
        cmp byte [sign_flag],1
        jne store_converted1
        mulsd xmm0,[negative]
        jmp store_converted1


store_converted1:
       mov qword [sign_flag],0
       movsd [converted_input1],xmm0
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
        mov al,[rsi]
        cmp al,'-'
        jne reload3
        mov rax,sign_flag
        mov byte [rax],1
        inc rsi
        jmp reload3


reload3:
        mov rbx,decimal_buffer2
        mov qword [rbx],0
        jmp convert_decimal2

convert_decimal2:
        mov rax,0
        mov al,[rsi]
        cmp al,10
        je int_to_float_conversion2
        cmp al,'.'
        je reload4
        sub al,'0'
        movzx rcx,al
        imul rax,[rbx],10
        add rax,rcx
        mov [rbx],rax
        inc rsi
        jmp convert_decimal2


reload4:
        mov rbx,fractional_buffer2
        mov qword [rbx],0
        mov rdx,1
        inc rsi
        jmp convert_fractional2


convert_fractional2:
        mov rax,0
        mov al,[rsi]
        cmp al,10
        je float_conversion2
        sub al,'0'
        movzx rcx,al
        imul rax,[rbx],10
        add rax,rcx
        mov [rbx],rax
        imul rdx,rdx,10
        inc rsi
        jmp convert_fractional2



int_to_float_conversion2:
        cvtsi2sd xmm0,[decimal_buffer2]
        cmp byte [sign_flag],1
        jne store_converted2
        mulsd xmm0,[negative]
        jmp store_converted2



float_conversion2:
        cvtsi2sd xmm0,[decimal_buffer2]
        cvtsi2sd xmm1,[fractional_buffer2]
        cvtsi2sd xmm2,rdx
        divsd xmm1,xmm2
        addsd xmm0,xmm1
        cmp byte [sign_flag],1
        jne store_converted2
        mulsd xmm0,[negative]
        jmp store_converted2


store_converted2:
        movsd [converted_input2],xmm0
        jmp a_operation



a_operation:
        mov byte [sign_flag],0
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
        movsd xmm0,[converted_input1]
        movsd xmm1,[converted_input2]
        addsd xmm0,xmm1
        jmp verify_sign3

subtraction:
        movsd xmm0,[converted_input1]
        movsd xmm1,[converted_input2]
        subsd xmm0,xmm1
        jmp verify_sign3

multiplication:
        movsd xmm0,[converted_input1]
        movsd xmm1,[converted_input2]
        mulsd xmm0,xmm1
        jmp verify_sign3

division:
        movsd xmm0,[converted_input1]
        movsd xmm1,[converted_input2]
        divsd xmm0,xmm1
        jmp verify_sign3


verify_sign3:
        xorpd xmm1,xmm1
        comisd xmm0,xmm1
        jnb convert_float_result
        mov byte [sign_flag],1
        mulsd xmm0,[negative]
        jmp convert_float_result


convert_float_result:
        cvttsd2si rax,xmm0
        cvtsi2sd xmm1,rax
        subsd xmm0,xmm1
        mulsd xmm0,[precision]
        cvttsd2si rbx,xmm0
        mov rcx,result_decimal_buffer
        mov [rcx],rax
        mov rcx,result_fractional_buffer
        mov [rcx],rbx
        jmp reload5

reload5:
        mov rax,[result_decimal_buffer]
        mov rbx,0
        mov rcx,10
        mov rsi,decimal_ascii_buffer
        jmp convert_decimal_to_ascii


convert_decimal_to_ascii:
        mov rdx,0
        cmp rax,0
        je reverse_resulting_ascii_decimal
        div rcx
        add dl,'0'
        mov [rsi],dl
        inc rsi
        inc rbx
        jmp decimal_storage

decimal_storage:
        mov rcx,result_decimal_ascii
        mov rdx,decimal_length
        mov [decimal_length],rbx
        jmp reverse_resulting_ascii_decimal


reverse_resulting_ascii_decimal:
        mov rax,0
        cmp rbx,0
        je reload6
        dec rsi
        mov al,[rsi]
        mov [rcx],al
        inc rcx
        dec rbx
        jmp reverse_resulting_ascii_decimal

reload6:
        mov rax,[result_fractional_buffer]
        mov rbx,0
        mov rcx,10
        mov rsi,fractional_ascii_buffer
        jmp convert_fractional_to_ascii


convert_fractional_to_ascii:
        mov rdx,0
        div rcx
        mov [rsi],dl
        inc rbx
        cmp rax,0
        je fractional_storage
        inc rsi
        jmp convert_fractional_to_ascii

   

fractional_storage:
        mov rcx,result_fractional_ascii
        mov rdx,fractional_length
        mov [rdx],rbx
        jmp reverse_resulting_ascii_fractional
 

reverse_resulting_ascii_fractional:
        mov rax,0
        cmp rbx,0
        je set_sign
        mov al,[rsi]
        mov [rcx],al
        inc rcx
        dec rsi
        dec rbx
        jmp reverse_resulting_ascii_fractional
    

set_sign:
        mov byte [rcx],10
        inc qword [rdx]
        cmp byte [sign_flag],1
        je print_sign
        jmp result

print_sign:
        mov rax,1
        mov rdi,1
        mov rsi,minus_char
        mov rdx,sign_len
        syscall
        jmp result

        
result:
        mov rax,1
        mov rdi,1
        mov rsi,result_decimal_ascii
        mov rdx,[decimal_length]
        syscall

        mov rax,1
        mov rdi,1
        mov rsi,comma
        mov rdx,comma_len
        syscall

        mov rax,1
        mov rdi,1
        mov rsi,result_fractional_ascii
        mov rdx,[fractional_length]
        syscall


        mov rax,60
        mov rdi,rax
        syscall