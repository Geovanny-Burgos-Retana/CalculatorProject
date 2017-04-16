;Calculadora entre bases numericas              CALCULATOR.ASM
;        Objective: Imprimir el  resultado en de una expresion
;                   ingresada por el usuario especificando las
;                   bases numericas de cada operando como tam-
;                   bien en base se debe mostrar el resultado.
;            Input: Requiere una expresion del usuarrio.
;           Output: Imprimir resultado de la expresion mostrando
;                   o no el procedimiento
%include "io.mac"
%include "conversiones.asm"
%include "limpiador.asm"

.DATA
menu            db  "  **********************************************************************",13,10
                db  "  *                    Bienvenido a nuestro programa                   *",13,10                
                db  "  **********************************************************************",13,10,0
interprete      db  ">> ",0
msgVariable     db  "-Error: Cifras numericas con simbolos incorrectos",0
msgDiv0         db  "-Error: Division entre 0",0
msgOverflow     db  "-Error: Desbordamiento en alguno de los pasos internos de las operaciones o el resultado",0
gracias         db  "Gracias por usar el programa",0
a               db  "Lee: ",0
Zf              db  0


.UDATA
expresion       resb 50
expPost         resb 50
operando        resd 1

.CODE
    .STARTUP
    PutStr menu
esperarExpresion:
    nwln
    call limpiar                ;Limpiamos expresion xq queda con datos de la pasada 
    PutStr interprete           ;Imprimir >>
    GetStr expresion,50         ;Obtener y guardar la expresion
    ;call a1
    cmp byte [expresion],1Bh    ;Comparar entrada con simbolo esc
    je terminar                 ;Sí cmp es igual salte para terminar programa
    sub eax,eax                 ;Limpiamos registro eax pra guardar el resultado del operando
    mov esi,expresion           ;Cargamos la direccion de memoria de donde inicia la expresion
    jmp procedExp               ;Salto incondicinal para inicia el procesamiento de la expresion
endNumero:
    sub eax,eax
    sub ecx,ecx                 ;Limpiar el registro ecx para reconocer inicio de nuevo operando
    sub ebx,ebx                 ;Limpiar registro ebx
procedExp:    
    mov edx,[esi]               ;Cargamos edx con el caracter en la posicion de memoria de esi
    cmp dl,0                    ;Comparamos con el valor nulo
    ;PutCh '$'
    je esperarExpresion         ;Sí cmp es igual salta para solicitar proxima expresion
    cmp dl,'$'
    je esperarExpresion         ;Sí cmp es igual salta para solicitar proxima expresion
    inc esi                     ;Incrementamos el esi para la siguiente celda de memri
    cmp dl,28h                  ;Comparaciones para determinar si el caracter procesando
    jl simbolo                  ;esta dentro del rango de caracteres validos para la 
    cmp dl,39h                  ;realizacion de las operaciones, si no esta en el conjunto
    jg char                     ;{()*+,-./0123456789}
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
;   jmp endNumero               ;Lo comente porque creo que nunca llega a realizar este salto        
oct:
    mov edi,8                   ;Operando octal entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    cmp ecx,3
    je overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    cmp ecx,5
    je simbolo
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
hexa:
    mov edi,16                  ;Operando hexadecimal entonces movemos la base al edi
    call hexadecimal            ;Llamada al procedimiento de conversion
    cmp ecx,3
    je overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    cmp ecx,5
    je simbolo
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
bin:
    mov edi,2                   ;Operando binario entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    cmp ecx,3
    je overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    cmp ecx,5
    je simbolo
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
deci:
    mov edi,10                  ;Operando decimal entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    cmp ecx,3
    je overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    cmp ecx,5
    je simbolo
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
simbolo:
    PutStr msgVariable          ;Imprimimos error si existe algun caracter invalido en la expresion
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
digBase:
    PutStr msgVariable           ;Imprimimos error si el operando tiene num. fuera del rango de la base
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
overflow:
    PutStr msgOverflow          ;Imprimimos error de desbordamieto en conversion o desarrollo de la exp
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
terminar:
    PutStr gracias
    nwln
    .EXIT
    
valorValido:
    
    ret
    
operador:
 
    ret
