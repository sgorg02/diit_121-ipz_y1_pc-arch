; сегмент даних
data segment para public	'data'
	A	dw 65533
	B dw 0
data ends

; сегмент стека
stk segment stack
	db 256 dup (?)	;поле для стека	розміром     256 байт
stk ends

; сегмент команд
code segment para public 'code'
	assume	     cs:code, ds:data, ss:stk
start:
	mov ax,	data	  ;ініціалізація сегментного регістра ds
	mov ds,	ax    ;	на програмний сегмент даних data


	mov ax, A
	mov bx, 10
	xor dx, dx

m1:
	cmp ax, 0
	jz mend

	div bx	     ; ax=новое	число, в dx = остаток
	mov cx, ax    ; cx = новое число

	mov di, dx
	mov ax, B
	mul bx

	add ax, di
	mov B, ax
	mov ax, cx
	jmp m1
mend:
	mov ax, 4C00h
	int 21h
code ends
	end start
