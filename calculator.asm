;Calculadora entre bases numericas              CALCULATOR.ASM
;        Objective: Imprimir el  resultado en de una expresion
;                   ingresada por el usuario especificando las
;                   bases numericas de cada operando como tam-
;                   bien en base se debe mostrar el resultado.
;            Input: Requiere una expresion del usuarrio.
;           Output: Imprimir resultado de la expresion mostrando
;                   o no el procedimiento
%include "io.mac"

.DATA
msgDivCero      db  "Error!! Ocurrio una division entre 0",0
msgOverflow     db  "Error!! Ocurrio un overflow",0
msgSintaxis     db  "Error!! Mal redaccion de la expresion",0
msgVariable     db  "Error!! Ingreso variables en la expresion",0

.UDATA
exprexion       resb 30

.CODE
    .STARTUP    
    
    .EXIT
