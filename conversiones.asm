;***********************************************************************************************
;strbaseToInt: Es una funcion para pasar el string octal,bin o decimal a su numero decimal correspodiente para su manejo adecuando en la resolicion de la expresion. Tambien es importante resaltar que el proc empieza desde el bit menos significativo hasta el mas significativo del operando. Tambien recordar que en el edi viene cargado con el numero de la base a convertir
;***********************************************************************************************
strbaseToInt:
    push esi                ;Guardamos en la pila el valor del registro esi
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
    jo stroverflow          ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    add eax,edx             ;Sumamos los otenido del numero procesado con el result final del op
    jo stroverflow          ;Si ocurriera desbordamiento debemos terminar el proceso pra notificar
    jmp strciclo            ;Saltamos para forma el ciclo para sacar el valor del operando
stroverflow:
    mov ecx,03h             ;Es para manejar en el principal que ocurrio un error de simbolo invalido
    jmp strfin
strDigInv:
    mov ecx,5               ;Es para manejar en el principal que ocurrio un error de simbolo invalido
strfin:
    PutLInt eax
    PutCh ' '
    pop esi                 ;Restauramos el registro esi que nos interesaba mantener
    ret                     ;Retornar la ip sig. instruccion antes de pasar al procedimiento
    
hexadecimal:
    
    ret
