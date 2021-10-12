sseg  segment  stack 'stack'  
    db  128 dup(?)
sseg  ends

dseg    segment 'data'

base        dw 10
minus       dw -1
txtin       db 'Enter text: $'
txtout      db 'Amount of words with mono-growing characters: $'
bufsize     db 255
bufread     db 0
buf         db 255 dup('$')

dseg    ends

cseg  segment  'code'
        assume  cs:cseg, ds:dseg, ss:sseg

textin proc near
    mov ah, 0Ah
    int 21h
    ret
textin endp

textout proc near
    mov ah, 09h
    int 21h
    ret
textout endp

chout proc near
    mov ah, 02h
    int 21h
    ret
chout endp

iteratechs proc near
    push ax
    mov bx, 0
    cmp cx, 0
    je return

chloop:
    mov ax, word ptr [di]
    cmp ah, ' '
    je space_found
    cmp ah, 0Dh
    je endline_found
    cmp ah, al
    ja endif_after
    mov bx, 1
endif_after:
    inc di
    loopne chloop
    jmp return
space_found:
    inc di
    dec cx
    jmp return
endline_found:
    dec cx

return:
    pop ax
    ret
iteratechs endp

iteratewords proc near
    push bx

wordloop:
    call iteratechs
    inc di
    cmp bx, 1
    je endif_seqgrow
    inc ax

endif_seqgrow:
    loop wordloop
    pop bx
    ret
iteratewords endp

numout proc near
    push bx
    push dx
    push cx

    cmp ax, 0
    jge output_number_unsigned
    imul minus
    xchg ax, bx
    mov dl, '-'
    call chout
    xchg ax, bx
output_number_unsigned:
    mov bx, 0
    mov cx, 0
output_number_loop:
    cmp ax, 0
    cwd
    idiv base
    add dl, '0'
    push dx
    inc bx
    cmp ax, 0
    loopne output_number_loop
    mov cx, bx
output_stack:
    pop dx
    call chout
    loop output_stack
    
    pop cx
    pop dx
    pop bx
    ret
numout endp

start:
    mov ax, dseg
    mov ds, ax

    lea dx, txtin
    call textout
    lea dx, bufsize
    call textin
    mov bx, 0
    mov ch, 0
    mov cl, bufread
    inc cx
    mov ax, 0
    cmp cl, 1
    je outputans
    lea di, buf
    call iteratewords

outputans:
    push ax
    mov dl, 0Ah
    call chout
    mov dl, 0Dh
    call chout
    lea dx, txtout
    call textout
    pop ax
    call numout

    mov dl, 0Ah
    call chout
    mov dl, 0Dh
    call chout
    mov ah, 4Ch
    int 21h

cseg    ends
        end start
