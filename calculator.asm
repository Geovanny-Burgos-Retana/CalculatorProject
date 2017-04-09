;Calculadora entre bases numericas              CALCULATOR.ASM
;        Objective: Imprimir el  resultado en de una expresion
;                   ingresada por el usuario especificando las
;                   bases numericas de cada operando como tam-
;                   bien en base se debe mostrar el resultado.
;            Input: Requiere una expresion del usuarrio.
;           Output: Imprimir resultado de la expresion mostrando
;                   o no el procedimiento
%include "io.mac"
%include "macros.asm"

.DATA
interprete      db  ">> ",0
msgDivCero      db  "Error!! Ocurrio una division entre 0",0
msgOverflow     db  "Error!! Ocurrio un overflow",0
msgSintaxis     db  "Error!! Mal redaccion de la expresion",0
msgVariable     db  "NameError: Variable o simbolo invalido",0
msgSum          db  "Procedimiento de suma",0
msgRes          db  "Procedimiento de resta",0
msgDiv          db  "Procedimiento de division",0
msgMul          db  "Procedimiento de multiplicacion",0
msgResult       db  "El resultado final es: ",0
prioriDP        db  "012",0
prioriFP        db  "512",0
pOperadores     dd  "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$",0

.UDATA
expresion       resd 50
expPost         resb 50
operando        resd 1

.CODE
    .STARTUP
esperarExpresion:
    PutStr interprete
    GetStr expresion
    cmp byte [expresion],'$'    ;Comparar entrada con simbolo dolar que es para salir del programa.
    je terminar
    sub eax,eax
    mov esi,expresion           ;Esi = dir. de memoria donde inicia la expresion
    jmp procedExp
endNumero:
    sub eax,eax
    sub ecx,ecx
    sub ebx,ebx
procedExp:
    mov edx,[esi]               ;EDX = caracter en la posicion de memoria ESI
    cmp edx,0
    je terminar
    inc esi
    cmp dl,28h                  ;Comparaciones para determinar si el caracter procesando
    jl simbolo                  ;esta dentro del rango de caracteres validos para la 
    cmp dl,39h                  ;realizacion de las operaciones
    jg char
    cmp dl,2Fh
    jle op
    cmp ecx,00
    je num
    jmp procedExp
num:
    mov ecx,1                   ;EBX = dir. de memoria de donde inicia el opeerando para
    mov ebx,esi                 ;luego procesarlo o convertirlo segun la base en la que
    sub ebx,1                   ;se encuentre. EBX -= 1 porque el esi de incremento antes
op:
    call operador
    jmp procedExp
char:
    cmp dl,'o'                  ;Comparaciones para reconocer en que base se encuentran
    je oct                      ;los distintos opereandos de la expresion tomando el
    cmp dl,'h'                  ;primer caracter en minuscula despues de los numeros o
    je hexa                     ;letras en mayuxcula de los valores hexadecimales
    cmp dl,'b'                  
    je bin
    cmp dl,'d'
    je deci
    jne simbolo
    jmp fin
oct:
    call octal
    jmp fin
hexa:
    call hexadecimal
    jmp fin
bin:
    call binario
    jmp fin
deci:
    call decimal
    jmp fin
simbolo:
    PutStr msgVariable
fin:
    jmp endNumero
terminar:
    .EXIT
    
;Convertir de string a decimal
decimal:
    push esi
    push ecx
    sub esi,1
    mov ecx,10
ciclo1:
    sub edx,edx
    cmp ebx,esi
    je fin1
    movzx edx,byte[ebx]
    inc ebx
    sub edx,30h
    imul eax,ecx
    jo overflow1
    add eax,edx
    jo overflow1
    jmp ciclo1
overflow1:
    PutStr msgOverflow
    mov ecx,01h
fin1:
    PutLInt eax
    pop ecx
    pop esi
    ret

;Convertir de string a octal
octal:
    push esi
    push ecx
    sub esi,2
    mov ecx,1
    sub ebx,1
ciclo2:
    cmp ebx,esi
    je fin2
    movzx edx,byte[esi]
    dec esi
    sub edx,30h
    imul edx,ecx
    imul ecx,8
    jo overflow2
    add eax,edx
    jo overflow2
    jmp ciclo2
overflow2:
    PutStr msgOverflow
    mov ecx,01h
fin2:
    PutLInt eax
    pop ecx
    pop esi
    ret

;Convertir de string a hexadecimal
hexadecimal:
    
    ret
;Convertir de string a binario
binario:
    push esi
    push ecx
    sub esi,2
    mov ecx,1
    sub ebx,1
ciclo4:
    cmp ebx,esi
    je fin4
    movzx edx,byte[esi]
    dec esi
    sub edx,30h
    imul edx,ecx
    imul ecx,2
    jo overflow4
    add eax,edx
    jo overflow4
    jmp ciclo4
overflow4:
    PutStr msgOverflow
    mov ecx,01h
fin4:
    PutLInt eax
    pop ecx
    pop esi
    ret
;Separar operadores con numeros
operador:
 
    ret
