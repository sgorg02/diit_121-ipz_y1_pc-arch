; сегмент даних
data segment para public 'data'
	A_answer	  db 13,10,'A-least of all',13,10,13,10,'$'

	B_answer	db 13,10,'B-least of all',13,10,13,10,'$'

	C_answer	db 13,10,'C-least of all',13,10,13,10,'$'

	A   db 25
	B   db 57
	C   db 154
data ends

; сегмент стека
stk segment stack
	db 256 dup (?)   ;поле для стека розміром	256 байт
stk ends

; сегмент команд
code segment para public 'code'
assume	cs:code, ds:data, ss:stk
start:
	mov ax, data	     ;ініціалізація сегментного	регістра ds
	mov ds, ax    ; на програмний сегмент даних data


	mov al, A
	mov ah, B

	cmp al, ah  ; A<B
	ja _c1	; проверка знака

	mov ah, C
	cmp al, ah  ; A<C
	ja _else
	lea dx,	A_answer
	jmp _exit

_c1:
	mov al, C
	cmp ah, al  ; B<C
	ja _else
	lea dx, B_answer
	jmp _exit

_else:
	lea dx, C_answer

_exit:
	mov ah, 09h ; блок вивелення повідомлення
	int 21h
	mov ax, 4C00h
	int 21h
code ends
	end start
