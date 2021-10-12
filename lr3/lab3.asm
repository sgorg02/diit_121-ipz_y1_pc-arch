; сегмент даних
data segment para public 'data'
	A	dw 12345
	B	dw -1234
	C	db 123
	D	db -12
	RES	  dw ?	;
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
	mov ds, ax	     ; на програмний сегмент даних data
	mov ax, 0
	mov al, C	     ; al = C
	idiv  D		     ; al = C /	D
	add al, D		     ; al = D +	C / D
	cbw
	mov bl, al
	mov ax, B
	cbw
	idiv bl		     ; eax = B/(D + C /	D)
	add al, D		     ; eax = D + B/(D +	C / D)
	mov bl, al
	mov ax, A
	idiv bl		     ; ax = A/(D + B/(D	+ C / D))
	sub ax, 275	     ; ax = A/(D + B/(D	+ C / D))-275
	mov RES, ax	     ;RES = ax = A/(D +	B/(D + C / D))-275
	mov ah, 4Ch
	int 21h
code ends
	end start