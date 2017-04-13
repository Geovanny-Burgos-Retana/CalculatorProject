;Macro para potencias, pow(base,exponente)
%macro pow 2
    mov eax,%1
    mov ecx,%2
    cmp ecx,0
    je pow0
    mov esi,eax
    dec ecx
siguiente:
    mul esi
    loop siguiente
pow0:    
    mov eax,1
%endmacro

;Macro para convertir de string decimal a numero decimal,
;convertBinToDec(direccion de memoria de inicio del numero)
%macro convertBinToDec 1
    mov esi,00
    mov ebx,%1
    mov eax,[ebx]    
siguiente:
    pow 10,esi
    pop edx
    inc esi
    mov eax,[ebx+esi]
    jmp siguiente
%endmacro

    
; ;Convertir de string a decimal
; decimal:
;     push esi
;     push ecx
;     sub esi,1
;     mov ecx,10
; ciclo1:
;     sub edx,edx
;     cmp ebx,esi
;     je fin1
;     movzx edx,byte[ebx]
;     inc ebx
;     sub edx,30h
;     imul eax,ecx
;     jo overflow1
;     add eax,edx
;     jo overflow1
;     jmp ciclo1
; overflow1:
;     mov ecx,01h
;     PutStr msgOverflow
; fin1:
;     PutLInt eax
;     PutCh ' '
;     pop ecx
;     pop esi
;     ret
; 
; ;Convertir de string a octal
; octal:
;     push esi
;     push ecx
;     sub esi,2
;     mov ecx,1
;     sub ebx,1
; ciclo2:
;     cmp ebx,esi
;     je fin2
;     movzx edx,byte[esi]
;     dec esi
;     sub edx,30h
;     imul edx,ecx
;     imul ecx,8
;     jo overflow2
;     add eax,edx
;     jo overflow2
;     jmp ciclo2
; overflow2:
;     mov ecx,01h
; fin2:
;     PutLInt eax
;     PutCh ' '
;     pop ecx
;     pop esi
;     ret
; 
; ;Convertir de string a hexadecimal
; hexadecimal:
;     
;     ret
; ;Convertir de string a binario
; binario:
;     push esi
;     push ecx
;     sub esi,2
;     mov ecx,1
;     sub ebx,1
; ciclo4:
;     cmp ebx,esi
;     je fin4
;     movzx edx,byte[esi]
;     dec esi
;     sub edx,30h
;     imul edx,ecx
;     imul ecx,2
;     jo overflow4
;     add eax,edx
;     jo overflow4
;     jmp ciclo4
; overflow4:
;     mov ecx,01h
; fin4:
;     PutLInt eax
;     PutCh ' '
;     pop ecx
;     pop esi
;     ret
