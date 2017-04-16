limpiar:
    mov eax,expresion
    mov cx,50
cicloLim:
    mov byte[eax],'$'
    inc eax
    loop cicloLim
finLim:
    ret

a1:
    PutStr a
    mov eax,expresion
    mov cx,50
c:
    mov ebx,[eax]
    inc eax
    PutCh bl
    PutCh '*'
    loop c
    nwln
    ret
