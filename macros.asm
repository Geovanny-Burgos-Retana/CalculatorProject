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
