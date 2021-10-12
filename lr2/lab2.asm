; сегмент даних
data segment para public 'data'
   txt db 'Honesty'
   A   db -57
   B   dw 2527
   C   dd -777666
   RES_A db ?
   RES_B dw ?
   RES_C dd ?
   RES       dw ?  ;
data ends
; сегмент стека
stk segment stack
                 db 256 dup (?)   ;поле для стека розміром 256 байт
stk ends

; сегмент команд
code segment para public 'code'
    assume cs:code, ds:data, ss:stk
start:
    mov ax, data  	;ініціалізація сегментного регістра ds 
    mov ds, ax   	; на програмний сегмент даних data   
    mov ax, 0

    mov al, txt

    mov ah, txt+1
    mov txt, ah
    
    mov ah, txt+2
    mov txt, ah

    mov ah, txt+3
    mov txt+2, ah

    mov ah, txt+4
    mov txt+3, ah

    mov ah, txt+5
    mov txt+4, ah

    mov ah, txt+6
    mov txt+5, ah

    mov txt+6, al

    mov RES, ax		? ? ?

; -57 -- -75    

    mov al, A+1

    mov ah, A+1
    mov A+2, ah

    mov A+3, al

    mov RES_A, ax ? ? ?

    int 21h
code ends
      end start