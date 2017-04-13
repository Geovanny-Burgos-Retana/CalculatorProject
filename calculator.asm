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
menu            db  "  **********************************************************************",13,10
                db  "  *Bienvenido a nuestro programa                                       *",13,10
                db  "  *Indicaciones generales:                                             *",13,10
                db  "  * -Despues de cada operando ingrese la minuscula para indicar la base*",13,10                
                db  "  **********************************************************************",13,10,0
interprete      db  ">> ",0
msgOverflow     db  "-Error: Desbordamiento",0
msgVariable     db  "-Error: Variable o simbolo invalido",0
msgDigOper      db  "-Error: Digito invalido para la base indicada",0
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
    cmp edx,00h                 ;Comparamos con el valor nulo
    je esperarExpresion         ;Sí cmp es igual salta para solicitar proxima expresion
    cmp dl,'$'
    je esperarExpresion         ;Sí cmp es igual salta para solicitar proxima expresion
    inc esi                     ;Incrementamos el esi para la siguiente celda de memri
    cmp dl,28h                  ;Comparaciones para determinar si el caracter procesando
;    jl simbolo                  ;esta dentro del rango de caracteres validos para la 
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
;    jne simbolo
;   jmp endNumero               ;Lo comente porque creo que nunca llega a realizar este salto        
oct:
    mov edi,8                   ;Operando octal entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    jo overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
hexa:
    mov edi,16                  ;Operando hexadecimal entonces movemos la base al edi
    call hexadecimal            ;Llamada al procedimiento de conversion
    jo overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
bin:
    mov edi,2                   ;Operando binario entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    jo overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
deci:
    mov edi,10                  ;Operando decimal entonces movemos la base al edi
    call strbaseToInt           ;Llamada al procedimiento de conversion
    jo overflow                 ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp endNumero               ;Saltamos si no hay overflow y si todo salio bien con la conversion
simbolo:
    PutStr msgVariable          ;Imprimimos error si existe algun caracter invalido en la expresion
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
digBase:
    PutStr msgDigOper           ;Imprimimos error si el operando tiene num. fuera del rango de la base
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
overflow:
    PutStr msgOverflow          ;Imprimimos error de desbordamieto en conversion o desarrollo de la exp
    jmp esperarExpresion        ;Saltamos para solicitar nueva expresion
terminar:
    PutStr gracias
    nwln
    .EXIT

hexadecimal:
    
    ret

;***********************************************************************************************
;strbaseToInt: Es una funcion para pasar el string octal,bin o decimal a su numero decimal correspodiente para su manejo adecuando en la resolicion de la expresion. Tambien es importante resaltar que el proc empieza desde el bit menos significativo hasta el mas significativo del operando. Tambien recordar que en el edi viene cargado con el numero de la base a convertir
;***********************************************************************************************
strbaseToInt:
    push esi                ;Guardamos en la pila el valor del registro esi
    push ecx                ;Guardamos en la pila el valor del registro ecx
    sub esi,2               ;Restamos el inc y para no tomar en cuenta el char de la base
    mov ecx,1               ;Es porque toda base empieza mul por b^0 que siempre es igual a 1
    sub ebx,1               ;Restamos para que no deje por fuera el bit mas significativo
strciclo:
    cmp ebx,esi             ;Cmp para ver si llegamos al final de los chars del operando
    je strfin               ;Saltamos a strfin si los registros ebx==esi
    movzx edx,byte[esi]     ;Movemos edx el caracter del numero siguiente
    dec esi                 ;Decrementamos para luego agarrar el sig. caracter del operando
    sub edx,30h             ;Restamos para obtener el decimal correspondiente al caracter
    cmp edi,edx             ;Cmp el numero para ver si esta en el rango para la base a convertir
    jle strDigInv           ;Si la cmp da menor o igual es porque el numero esta fuera del rango
    imul edx,ecx            ;Multiplica la base elevada al exponente segun la posicion
    imul ecx,edi            ;Multiplicamos para seguir con el siguiente exponente
    jo overflow             ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    add eax,edx             ;Sumamos los otenido del numero procesado con el result final del op
    jo overflow             ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp strciclo            ;Saltamos para forma el ciclo para sacar el valor del operando
stroverflow:
    mov ecx,01h             ;NO Recuerdo :(
    jmp strfin
strDigInv:
    mov ecx,02h             ;Tengo que analizarlo porque no recuerdo :(
strfin:
    PutLInt eax
    PutCh ' '
    pop ecx                 ;Restauramos el registro ecx que nos interesaba mantener
    pop esi                 ;Restauramos el registro esi que nos interesaba mantener
    ret                     ;Retornar la ip sig. instruccion antes de pasar al procedimiento

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
    
    
valorValido:
    
    ret
    
operador:
 
    ret
