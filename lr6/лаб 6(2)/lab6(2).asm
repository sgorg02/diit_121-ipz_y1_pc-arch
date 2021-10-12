;-------------------------------------------------------------------------------
;Програма роботи з масивом чисел. 
;Елементи масиву – цілі числа зі знаком з діапазону слово.
;Вхід: розмір масиву та його елементи вводяться з клавіатури, число с яким будемо порівнювати елементи масива.
;Вихід: оновлений масив виводиться на консоль, кількість та сума елементів масиву які більше за задане число.
;-------------------------------------------------------------------------------


;сегмент стеку
stk	segment	stack
	db	256 dup (?)
stk	ends

;сегмент даних
data		segment para public 'data'
len		dw	10			;максимальний розмір масиву
counter		dw	?		;розмір масиву
division	db	5
sum		dw	0
quantity dw	0
A		dw	10 dup (?)	;масив
Comparison_Number dw ?	;число с яким будемо порівнювати елементи масива(число должен вводить пользеватель)
;буфер для введення числа в ASCII-формі (максимум 6 символів (-32768) + кінець рядка (0dh))
buffer		db	7, ?, 7 dup (?)
buffer2		db	7, ?, 7 dup (?)
msgQuantity	db	'Number of items greater than the number entered: $'
msgPrintsum	db	'The sum of the elements that is greater than the number entered: $'		
msgCounter	db	'Enter the number of elements in the array N (5 <= N <= 10): $'
msgArray	db	'Enter array elements:', 0ah, 0dh, '$'
msgPrompt1	db	'A [ $'
msgPrompt2	db	' ] = $'
msgError	db	0ah, 0dh, 'ERROR!', 0ah, 0dh, '$'
msgPrint	db	'Array :', 0ah, 0dh, '$'
msgPause	db	'Press any key ...', '$'
CrLf		db	0ah, 0dh, '$'
data		ends

;сегмент команд
code	segment para public 'code'
	assume	cs:code, ds:data, ss:stk
main:	
	mov	ax, data			
	mov	ds, ax			

mInCounter1:	
	lea	dx, msgQuantity		;виведення запрошення для введення числа
	call	outString			
	lea	dx, buffer2			;DX = адреса буфера
	mov	ah, 0ah				;введення рядка в буфер 
	int	21h	
	cmp	buffer2 + 1, 0		;перевірка довжини рядка
	call	convertStrToInt	;перетворення рядка в слово (число зі знаком)
	jc	mErrorCounter1		;якщо помилка, то виведення повідомлення
	mov Comparison_Number, ax
	lea	dx, CrLf
	call	outString
	jmp mEndLoop1
mErrorCounter1:
	lea	dx, msgError
	call	outString		;виведення повідомлення 'ERROR!'
	jmp	mInCounter1			;перехід до початку циклу
mEndLoop1:

;введення кількості елементів масиву (цикл повторюється до введення "правильного" числа)
mInCounter:	
	lea	dx, msgCounter		;виведення запрошення для введення числа
	call	outString			
	lea	dx, buffer			;DX = адреса буфера
	mov	ah, 0ah				;введення рядка в буфер 
	int	21h	
	cmp	buffer + 1, 0		;перевірка довжини рядка
	jz	mInCounter			;якщо довжина = 0, перехід до початку циклу
	call	convertStrToInt	;перетворення рядка в слово (число зі знаком)			
	jc	mErrorCounter		;якщо помилка, то виведення повідомлення
	cmp	ax, len				;якщо кількість елементів > розміру масиву,
	jg	mErrorCounter		;то перехід на повідомлення про помилку
	cmp	ax, 4				;якщо кількість елементів <= 4,
	jle	mErrorCounter		;то перехід на повідомлення про помилку
	mov	counter, ax			;збереження кількості елементів масиву
	lea	dx, CrLf			;виведення управляючих символів
	call	outString			
	jmp	mEndLoop			;вихід з циклу введення кількості елементів 
mErrorCounter:
	lea	dx, msgError
	call	outString		;виведення повідомлення 'ERROR!'
	jmp	mInCounter			;перехід до початку циклу
mEndLoop:   
;введення елементів масиву
	lea	dx, msgArray		;виведення запрошення для елементів масиву
	call	outString						
	mov	cx, counter			;лічильник циклу введення елементів масиву
	xor	si, si				;індекс елементів масиву
;введення елементу масиву
mInArray:
	call	outPrompt		;виведення запрошення для елемента масиву
	lea	dx, buffer			;DX = адреса буфера
	mov	ah, 0ah				;введення рядка в буфер 
	int	21h	
	cmp	buffer + 1, 0		;перевірка довжини рядка
	jz	mInArray			;якщо довжина = 0, перехід до початку циклу
	call	convertStrToInt	;перетворення рядка в число зі знаком (слово)
	jnc	mElementOk			;якщо немає помилки, то збереження елементу
	lea	dx, msgError		;інакше виведення повідомлення 'ERROR!'
	call	outString		
	jmp	mInArray			;перехід до початку циклу
mElementOk:
	mov	di, si				;DI = індекс поточного елементу масиву
	add	di, di				;DI = зміщення поточного елементу
	mov	A[di], ax			;збереження поточного елементу масиву 
	inc	si					;перехід до наступного елементу масиву 
	lea	dx, CrLf			;виведення управляючих символів
	call	outString			
	loop 	mInArray		;якщо не всі елементи введені - до початку циклу
;виведення масиву на консоль		
	lea	dx, msgPrint		;виведення повідомлення 
	call	outString						
	mov	cx, counter			;лічильник циклу виведення елементів масиву
	xor	si, si				;індекс поточного елементу масиву A
mPrintArray:
	call	outPrompt		;виведення "імені" елемента масиву
	mov	di, si				;DI = індекс поточного елементу масиву
	add	di, di				;DI = зміщення поточного елементу
	mov	ax, A[di]			;AX = поточний елемент
	call	printInt		;виведення поточного елементу
	lea	dx, CrLf			;виведення управляючих символів
	call	outString
	inc	si					;перехід до наступного елементу масиву 
	loop	mPrintArray		;не всі елементи виведені - на початок циклу
	xor	di, di
	mov	cx, counter
	mov	bx, 0
mCondition:
	mov 	ax, A[di]
	cmp	ax, Comparison_Number 
	jl 		mNext
	add 	bx, A[di]
	inc 	quantity
mNext:
	inc 	di
	inc		di
	loop	mCondition 
mPrintsum:
	lea 	dx, msgPrintsum
	call	outString
	mov	ax, bx
	call	printInt
	lea	dx, CrLf			;виведення управляючих символів
	call	outString
	lea	dx, msgQuantity
	call	outString
	mov	ax, quantity
	call	printInt
	lea	dx, CrLf			;виведення управляючих символів
	call	outString
;затримка виконання та вихід з програми
	lea	dx, msgPause	
	call	outString		;виведення повідомлення 'Press any key...'
	mov	ah, 08h				;затримка виконання програми 
	int	21h		
	mov	ax, 4C00h	   		;завершення програми
	int	21h				
;-------------------------------------------------------------------------------
;процедура виведення рядка символів, обмежених символом '$' на консоль
;вхід: DX - адреса рядка 
;-------------------------------------------------------------------------------
outString	proc near		
	mov 	ah, 09h		
	int	21h			
	ret	
outString	endp
;-------------------------------------------------------------------------------
;процедура виведення на консоль імені масиву та індексу елемента
;-------------------------------------------------------------------------------
outPrompt	proc near		
	lea	dx, msgPrompt1		;виведення імені масиву
	call	outString			
	mov	ax, si				;AX = індекс елементу масиву
	call	printInt		;виведення індексу
	lea	dx, msgPrompt2		
	call	outString			
	ret
outPrompt	endp
;-------------------------------------------------------------------------------
;процедура перетворення рядка в число зі знаком в форматі слова
;(діапазон значення числа від -32768 до 32767)
;вхід:  DX - адреса буфера 
;вихід: AX - число в форматі слова (в разі помилки AX = 0)
;       CF = 1 - помилка
;-------------------------------------------------------------------------------
convertStrToInt	proc near
;збереження регістрів			
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	mov	si, dx				;SI - адреса буфера
	xor	cx, cx
	mov	cl, [si + 1]		;CL = довжина введеного рядка
;перевірка знаку числа
	add	si, 2				;SI - адреса рядка
	mov	bl, [si]			;BL = перший символ рядка
	cmp	bl, '-'				;порівняння першого символу з '-'
	jne	mNoSign				;якщо не '-', то перетворюємо рядок як число без знаку
	inc	si					;інкремент адреси рядка
	dec	cl					;декремент довжини рядка
;перетворення рядка у слово без знаку
mNoSign:								
	mov	bp, bx				;зберігаємо регістр			
	xor	bx, bx
	mov	di, 10				;DI = множник 10 (база системи числення)
	xor	ax, ax				;AX = 0, для обчислення числа, яке введене з клавіатури
mScanString:
	mov	bl, [si]			;завантаження в BL чергового символу рядка
	inc	si					;інкремент адреси
	cmp	bl, '0'				;якщо код символу менше коду '0'
	jb	mErrorValue			;повертаємо помилку
	cmp	bl, '9'				;якщо код символу більше коду '9'
	ja	mErrorValue			;повертаємо помилку
	sub	bl, '0'				;перетворення символу-цифри в число
	mul	di					;AX = AX * 10
	jc	mErrorValue			;якщо результат більше 16 бітів - помилка
	add	ax, bx				;додаємо цифру
	jc	mErrorValue			;якщо переповнення - помилка
	loop	mScanString		;продовжуємо сканувати рядок
;обробка знаку числа та перевірка діапазону для від'ємного числа
	mov	bx, bp				;відновлюємо регістр			
	cmp	bl, '-'				;знову перевіряємо знак
	jne	mPlus				;якщо перший символ не '-', то число додатне
	cmp	ax, 32768			;модуль від'ємного числа повинен бути не більш 32768
	ja	mErrorValue			;якщо більше (без знаку), повертаємо помилку
	neg	ax					;інвертуємо число (число - від'ємне)
	jmp	mOk					;переходимо до нормального завершення процедури
;перевірка діапазону для додатного числа
mPlus: 
	cmp	ax, 32767			;додатне число повинно бути не більше 32767
	ja	mErrorValue			;якщо більше, повертаємо помилку
;успішне перетворення рядка у число в форматі слова
mOk: 
	clc 					;CF = 0 ознака успішного перетворення рядка у число
	jmp	mExit				;переходимо до виходу з процедури
;помилка перетворення рядка у число в форматі слова
mErrorValue: 
	xor	ax, ax				;AX = 0
	stc						;CF = 1 повертаємо помилку
mExit:	
;відновлення регістрів	
	pop	bp		
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	ret
convertStrToInt	endp
;-------------------------------------------------------------------------------
;процедура виведення цілого числа у форматі слова на консоль
;вхід: AX - ціле число
;-------------------------------------------------------------------------------
printInt	proc near
;збереження регістрів			
	push	ax
	push	bx
	push	cx
	push	dx
;обробка знаку числа AX
	cmp	ax, 0			;якщо число додатне
	jge	mPositive		;перехід до його обробки
	neg	ax				;інакше - перетворення від'ємного числа на додатне
	push	ax
	mov	dl, '-'			;виведення на консоль 
	mov	ah, 02h			;знаку '-'
	int	21h
	pop	ax
;обробка додатного числа
mPositive:			
	mov	bx, 10
	xor	cx, cx			;лічильник цифр числа
;отримуємо цифри числа AX
mDivisionNumber:
	cwd
	div	bx				;ділимо з остачею
	push	dx			;зберігаємо остачу в стеку
	inc	cx				;збільшуємо лічильник цифр числа
	or	ax, ax			;якщо число ще не 0,
	jnz	mDivisionNumber	;продовжуємо цикл	
;виведення на консоль цифр числа AX
mPrintChar:
	pop	dx				;DX = цифра числа
	add	dl, 30h			;DL = символ цифри числа
	mov	ah, 02h			;виведення символу-цифри на консоль
	int	21h
	loop	mPrintChar	;лічильник цифр числа не 0 - продовжуємо цикл
;відновлення регістрів			
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret	
printInt	endp
;-------------------------------------------------------------------------------
code	ends  
	end	main
