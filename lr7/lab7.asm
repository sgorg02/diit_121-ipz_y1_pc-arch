;-------------------------------------------------------------------------------
;Програма роботи з	масивом	чисел.
;Елементи масиву –	цілі числа зі знаком з діапазону слово.
;Вхід: розмір масиву та його елементи вводяться з клавіатури, число с яким	будемо порівнювати  +елементи масива.
;Вихід: оновлений масив виводиться	на консоль, кількість та сума елементів	масиву які більше за+задане число.
;-------------------------------------------------------------------------------


;сегмент стеку
stk     segment stack
	db	     256 dup (?)
stk     ends

;сегмент даних
data	     segment para public 'data'
	len	     dw	     10			     ;максимальний розмір масиву
	counter	 dw	     ?		     ;розмір масиву
	division db	     5
	sum	     dw	     0
	quantity dw     0
	A		 dw	     10	dup (?)	     ;масив
Comparison_Number dw ?  ;число с яким будемо порівнювати елементи масива(число должен вводить  + пользеватель)
;буфер для	введення числа в ASCII-формі (максимум 6 символів (-32768) + кінець рядка (0dh))
	buffer	     	db	     7,	?, 7 dup (?)
	buffer2	     	db	     7,	?, 7 dup (?)
	msgQuantity     db	     'Number of	items greater than the number entered: $'
	msgPrintsum     db	     'The sum of the elements that is greater than the number entered: $'
	msgCounter	    db	     'Enter the	number of elements in the array	N (5 <=	N <= 10): $'
	msgArray	    db	     'Enter array elements:', 0ah, 0dh,	'$'
	msgError	   	db	     0ah, 0dh, 'ERROR!', 0ah, 0dh, '$'
	msgPrint	    db	     'Array :',	0ah, 0dh, '$'
	msgPause	    db	     'Press any	key ...', '$'
	CrLf	     	db	     0ah, 0dh, '$'
	data	     ends

extrn outString:near
extrn outPrompt:near
extrn convertStrToInt:near
extrn printInt:near
;сегмент команд
code    segment para public 'code'
	assume  cs:code, ds:data, ss:stk
main proc far
	mov     ax, data
	mov     ds, ax

mInCounter1:
	lea     dx, msgQuantity	     ;виведення	запрошення для введення	числа
	call    outString
	lea     dx, buffer2		     ;DX = адреса буфера
	mov     ah, 0ah			     ;введення рядка в буфер
	int     21h
	cmp     buffer2 + 1, 0	     ;перевірка	довжини	рядка
	call    convertStrToInt 	 ;перетворення рядка в слово (число	зі знаком)
	jc	     mErrorCounter1	     ;якщо помилка, то виведення повідомлення
	mov Comparison_Number, ax
	lea     dx, CrLf
	call    outString
	jmp mEndLoop1

mErrorCounter1:
	lea     dx, msgError
	call    outString		     ;виведення	повідомлення 'ERROR!'
	jmp     mInCounter1		     ;перехід до початку циклу
mEndLoop1:

;введення кількості елементів масиву (цикл	повторюється до	введення "правильного" числа)
mInCounter:
	lea     dx, msgCounter	     ;виведення	запрошення для введення	числа
	call    outString
	lea     dx, buffer			 ;DX = адреса буфера
	mov     ah, 0ah			     ;введення рядка в буфер
	int     21h
	cmp     buffer + 1, 0	     ;перевірка	довжини	рядка
	jz	     mInCounter			 ;якщо довжина = 0,	перехід	до початку циклу
	call    convertStrToInt 	 ;перетворення рядка в слово (число	зі знаком)
	jc	     mErrorCounter	     ;якщо помилка, то виведення повідомлення
	cmp     ax, len			     ;якщо кількість елементів > розміру масиву,
	jg	     mErrorCounter	     ;то перехід на повідомлення про помилку
	cmp     ax, 4			     ;якщо кількість елементів <= 4,
	jle     mErrorCounter	     ;то перехід на повідомлення про помилку
	mov     counter, ax		     ;збереження кількості елементів масиву
	lea     dx, CrLf			 ;виведення	управляючих символів
	call    outString
	jmp     mEndLoop			 ;вихід з циклу введення кількості елементів

mErrorCounter:
	lea     dx, msgError
	call    outString		     ;виведення	повідомлення 'ERROR!'
	jmp     mInCounter			 ;перехід до початку циклу

mEndLoop: ;введення елементів масиву
	lea     dx, msgArray	     ;виведення	запрошення для елементів масиву
	call    outString
	mov     cx, counter		     ;лічильник	циклу введення елементів масиву
	xor     si, si			     ;індекс елементів масиву

mInArray: ;введення елементу	масиву
	call    outPrompt		     ;виведення	запрошення для елемента	масиву
	lea     dx, buffer			 ;DX = адреса буфера
	mov     ah, 0ah			     ;введення рядка в буфер
	int     21h
	cmp     buffer + 1, 0	     ;перевірка	довжини	рядка
	jz	     mInArray			 ;якщо довжина = 0,	перехід	до початку циклу
	call    convertStrToInt ;перетворення рядка в число зі знаком (слово)
	jnc     mElementOk			 ;якщо немає помилки, то збереження	елементу
	lea     dx, msgError	     ;інакше виведення повідомлення 'ERROR!'
	call    outString
	jmp     mInArray			 ;перехід до початку циклу

mElementOk:
	mov     di, si			     ;DI = індекс поточного елементу масиву
	add     di, di			     ;DI = зміщення поточного елементу
	mov     A[di], ax			 ;збереження поточного елементу масиву
	inc     si					 ;перехід до наступного елементу масиву
	lea     dx, CrLf			 ;виведення	управляючих символів
	call    outString
	loop    mInArray		     ;якщо не всі елементи введені - до	початку	циклу
;виведення	масиву на консоль
	lea     dx, msgPrint	     ;виведення	повідомлення
	call    outString
	mov     cx, counter		     ;лічильник	циклу виведення	елементів масиву
	xor     si, si			     ;індекс поточного елементу	масиву A

mPrintArray:
	call    outPrompt		     ;виведення	"імені"	елемента масиву
	mov     di, si			     ;DI = індекс поточного елементу масиву
	add     di, di			     ;DI = зміщення поточного елементу
	mov     ax, A[di]			 ;AX = поточний елемент
	call    printInt		     ;виведення	поточного елементу
	lea     dx, CrLf			 ;виведення	управляючих символів
	call    outString
	inc     si					 ;перехід до наступного елементу масиву
	loop    mPrintArray	     	 ;не всі елементи виведені - на початок циклу
	xor     di, di
	mov     cx, counter
	mov     bx, 0

mCondition:
	mov     ax, A[di]
	cmp     ax, Comparison_Number
	jl		     mNext
	add     bx, A[di]
	inc     quantity

mNext:
	inc     di
	inc	     di
	loop    mCondition

mPrintsum:
	lea     dx, msgPrintsum
	call    outString
	mov     ax, bx
	call    printInt
	lea     dx, CrLf			 ;виведення	управляючих символів
	call    outString
	lea     dx, msgQuantity
	call    outString
	mov     ax, quantity
	call    printInt
	lea     dx, CrLf			 ;виведення	управляючих символів
	call    outString
;затримка виконання та вихід з програми
	lea     dx, msgPause
	call    outString		     ;виведення	повідомлення 'Press any	key...'
	mov     ah, 08h			     ;затримка виконання програми
	int     21h
	mov     ax, 4C00h			 ;завершення програми
	int     21h
main endp
code    ends
	end     main