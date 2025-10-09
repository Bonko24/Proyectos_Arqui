;-------MACROS------

;Inicio
IniciaSegmentoDatos Macro SegDatos
    xor ax,ax                                                       ;Inicializa Segmento
    mov ax,SegDatos
    mov ds,ax     
EndM

ClearScreen Macro filaInf, columInf, filaSup, ColumSup, Atrib       ;Limpia pantalla
    pushA
    mov ah,07h
    xor al,al
    mov bh,atrib
    mov ch,filaInf
    mov cl,columInf
    mov dh,filaSup
    mov dl,columSup
    int 10h
    popA
EndM

WhereXY Macro X,Y                                                   ;Buscar posicion del cursor
    pushA
    mov ah,03h
    xor bh,bh
    mov dh,X
    mov dl,y
    int 10h
    popA
EndM

GotoXY Macro X,Y                                                    ;Pone cursor en la posicion xy
    pushA
    mov ah,02h
    xor bh,bh
    mov dh,X
    mov dl,y
    int 10h
    popA
EndM

WaitKey Macro                                                       ;Espera un input de teclado
    push ax
    mov ah,01h
    int 21h
    pop ax
EndM 

ReadChar Macro variable                                             ;Lee un caracter
    push ax
    mov ah,01h
    int 21h
    mov variable,al                                                 ;la variable debe de ser db.
    pop ax
EndM

ImprimirString Macro mensaje                                        ;Imprime string
    pushA
    mov ah,09h
    mov dx,offset mensaje
    int 21h
    popA
EndM

;Num debe venir en forma decimal, es decir con un signo ASCII
;ejem: 5 es un trebol, ya que el 5 de consola entra como 35h
;y eso nos da un 5 en decimal restandole 30h
ImprimirNum Macro num
    pushA
    mov dl,num
    add dl,30h
    mov ah,02h
    int 21h
    popA
ENDM

ImprimirSeparador Macro                                             ;Imprimir una , 
    pushA
    mov dl,','
    mov ah,02h
    int 21h
    popA
ENDM

PrintChar Macro caracter                                            ;Imprime un caracter 
    pushA
    mov ah,02h
    mov dl,caracter
    int 21h
    popA
EndM

PrintCharColor Macro caracter, color, cantidad                      ;Imprime un caracter al=caracter a imprimir, bl = color, cx = cantidad de veces
    pushA
    mov ah,09h
    mov al,caracter
    xor bh,bh   
    mov bl,color
    mov cx,cantidad
    int 10h
    popA
EndM

TerminaPrograma Macro codigosalida                                  ;Termina el programa
    mov ah,4ch
    mov al,codigosalida
    int 21h
EndM

; --Macros Proyecto 1: Mini Calculadora--
AjustarNumM Macro var, factor, destino
    mov    ax,00                                                    ;limpiar ax
    mov    al,var                                                   ;poner en al el valor de var
    mov    bl,factor                                                ;poner en bl el factor al que se va a ajustar 
    mul    bl                                                       ;multiplicar al por factor
    mov    destino,ax                                               ;guardar el resultado en conver1
EndM

; Macro para realizar la multiplicación 
MultM Macro u, d, c, u1, d1, c1, registro, auxiliar, cero, uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, diez, once
    xor         ax,ax                                               ;limpiar ax
    xor         bx,bx
    ;multiplicar u por u1
    mov         al,u                                                ;unidades num1 en al
    mov         bl,u1                                               ;unidades num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desenpaquetar registro
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         cero,al                                             ;guardar resultado de unidades en cero
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d por u1                   
    mov         al,d                                                ;decenas num1 en al
    mov         bl,u1                                               ;unidades num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al (sumar el carry anterior)
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         uno,al                                              ;guardar resultado de unidades en uno
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c por u1                   
    mov         al,c                                                ;centenas num1 en al
    mov         bl,u1                                               ;unidades num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         dos,al                                              ;guardar resultado de unidades en dos
    mov         tres,ah                                             ;guardar el resultado de decenas en tres (carry)
    ;multiplicar u con d1                   
    mov         al,u                                                ;unidades num1 en al
    mov         bl,d1                                               ;decenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         cuatro,al                                           ;guardar resultado de unidades en cuatro
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d con d1                   
    mov         al,d                                                ;decenas num1 en al
    mov         bl,d1                                               ;decenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         cinco,al                                            ;guardar resultado de unidades en cinco
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c con d1                   
    mov         al,c                                                ;centenas num1 en al
    mov         bl,d1                                               ;decenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         seis,al                                             ;guardar resultado de unidades en seis
    mov         siete,ah                                            ;guardar el resultado de decenas en siete (carry)
    ;multiplicar u con c1                   
    mov         al,u                                                ;unidades num1 en al
    mov         bl,c1                                               ;centenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         ocho,al                                             ;guardar resultado de unidades en ocho
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d con c1                   
    mov         al,d                                                ;decenas num1 en al
    mov         bl,c1                                               ;centenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         nueve,al                                            ;guardar resultado de unidades en nueve
    mov         auxiliar,ah                                         ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c con c1                   
    mov         al,c                                                ;centenas num1 en al
    mov         bl,c1                                               ;centenas num2 en bl
    mul         bl                                                  ;multiplicar al por bl
    add         al,auxiliar                                         ;sumar auxiliar a al
    mov         registro,al                                         ;almacenar decenas de resultado en registro
    ;desempaquetar registro                 
    mov         al,registro                                         ;guardar registro en al
    aam                                                             ;ajustar ax para separar decenas y unidades
    mov         diez,al                                             ;guardar resultado de unidades en diez
    mov         once,ah                                             ;guardar el resultado de decenas en once (carry)
    ;sumamos resultados                 
    mov         al,uno                                              ;almacenar uno en al
    add         al,cuatro                                           ;sumar al con cuatro
    aam                                                             ;separar decenas y unidades de resultado
    mov         uno,al                                              ;decenas en uno (resultado final)
    mov         auxiliar,ah                                         ;decenas en auxiliar (carry)
    mov         al,dos                                              ;almacenar dos en al
    add         al,cinco                                            ;sumar al con cinco
    add         al,ocho                                             ;sumar al con ocho
    add         al,auxiliar                                         ;sumar al con auxiliar (carry)
    aam                                                             ;separar decenas y unidades de resultado
    mov         dos,al                                              ;centenas en dos (resultado final)
    mov         auxiliar,ah                                         ;decenas en auxiliar (carry)
    mov         al,tres                                             ;almacenar tres en al
    add         al,seis                                             ;sumar al con seis
    add         al,nueve                                            ;sumar al con nueve
    add         al,auxiliar                                         ;sumar al con auxiliar (carry)
    aam                                                             ;separar decenas y unidades de resultado
    mov         tres,al                                             ;decenas en tres (resultado final)
    mov         auxiliar,ah                                         ;decenas en auxiliar (carry)
    mov         al,siete                                            ;almacenar siete en al
    add         al,diez                                             ;sumar al con diez
    add         al,auxiliar                                         ;sumar al con auxiliar (carry)
    aam                                                             ;separar decenas y unidades de resultado
    mov         siete,al                                            ;centenas en siete (resultado final)
    mov         auxiliar,ah                                         ;decenas en auxiliar (carry)
    mov         al,once                                             ;almacenar once en al
    add         al,auxiliar                                         ;sumar al con auxiliar (carry)
    mov         once,al                                             ;decenas en once (resultado final)
EndM

; Obtiene la línea de comando del psp 
GetCommanderLineM Macro segDatos, linecommand
    LongLC  EQU    80h
        mov    ax,es
        mov    ds,ax
        mov    di,linecommand
        mov    ax,segDatos
        mov    es,ax
        xor    cx,cx
        mov    cl,Byte ptr DS:[LongLC]
        dec    cl
        mov    si,2[LongLC]
        cld
        rep    movsb
EndM
; bufferDiv = buffer que guarda el resutado y entero = parte entera del resultad
Print_NumM Macro bufferDiv, entero
    push   dx                                                       ;guarda el residuo de la división (parte decimal)           
    mov    di, bufferDiv                                            ;buffer de división
    mov    ax, entero                                               ;numero a convertir
    mov    bx,10                                                    ;divisor para convertir a decimal
    xor    dx,dx                                                    ;extender el dividendo a 32 bits (DX:AX)
    div    bx                                                       ;dividir ax entre bx, AX = cociente (parte entera), DX = residuo (parte decimal)
    add    dx,'0'                                                   ;convertir el digito a su caracter ASCII
    mov    [di],dl                                                  ;guardar el digito en el buffer
    dec    di                                                       ;decrementar el puntero al buffer
    mov    bufferDiv,di                                             ;buffer de división
    mov    entero, ax 
    pop    dx                                                       ;numero a convertir

EndM

    ;rutina para imprimir la parte fraccionaria del numero
    ;recibe: bx = numero a convertir
    ;retorna nada
Print_DecM Macro bufferDiv, decimal
    mov    di,bufferDiv
    mov    ax,decimal                                               ;numero a convertir
    mov    bx,10                                                    ;divisor para convertir a decimal

    ;Primer decimal
    mov    dx,0;extender el dividendo a 32 bits (DX:AX)
    div    bx
    add    al,'0'
    mov    [di],al                                                  ;guardar el digito en el buffer
    mov    ax,dx                                                    ;almacenar residuo para siguiente digito
    inc    di                                               
    ;Segundo decimal                                                
    add    dl,'0'                                                   ;segundo decimal a ASCII
    mov    [di],dl                                                  ;guardar dìgito en el buffer
EndM

; Convertir de ASCII a numero
ConversionNumM Macro var
    mov    var, ax
    sub    var, 30h
EndM

; Armar un numero de sus unidades, decenas y centenas 
ArmarM Macro u, d, c, num
    xor    ax,ax                                                    ;limpiar ax
    mov    ax,u                                                     ;poner en ax el valor de conver1
    add    num,ax                                                   ;sumar conver1 a la suma
    mov    ax,d                                                     ;poner en ax el valor de conver2
    add    num,ax                                                   ;sumar conver2 a suma
    mov    al,c                                                     ;poner en al el valor de u
    add    num,ax                                                   ;sumar u a suma
EndM


; Sumar dos numeros de 3 dígitos 
SumaM Macro num1, num2, resultado

    xor    ax,ax                                                    ;limpiar ax
    mov    ax, num1                                                 ;poner en ax el valor de num1
    add    resultado, ax                                            ;sumar num1 a resultado
    mov    ax, num2                                                 ;poner en ax el valor de num2
    add    resultado, ax                                            ;sumar num2 a resultado

EndM

; Imprimir resultado para suma y resta
ImprimirResultadoSRM Macro u,d,c,uMillar,resultado
    xor    ax,ax                                                    ;limpiar ax
    mov    ax, resultado                                            ;poner en ax el valor de suma
    mov    dl,10                                                    ;poner en dl 10 para ajustar
    div    dl                                                       ;separar unidades
    mov    u,ah                                                     ;guardar unidades en u
    mov    ah,00h                                                   ;limpiar ah
    div    dl                                                       ;separar decenas y centenas
    mov    d,ah                                                     ;guardar decenas en d
    mov    ah,00h                                                   ;limpiar ah
    div    dl                                                       ;separar centenas y uMillar
    mov    c,ah                                                     ;guardar centenas en c
    mov    uMillar,al                                               ;guardar miles en uMillar
    ImprimirNum uMillar                                             ;llamar a PrintNum para imprimir el resultado
    ImprimirNum c                                                   ;reservar espacio en la pila para c
    ImprimirNum c                                                   ;llamar a PrintNum para imprimir el resultado
    ImprimirNum d                                                   ;llamar a PrintNum para imprimir el resultado
    ImprimirNum u                                                   ;llamar a PrintNum para imprimir el resultado
EndM

; Restar dos numeros de 3 dígitos 
RestaM Macro num1, num2, resta
    xor    ax,ax                                                    ;limpiar ax
    mov    ax, num1                                                 ;poner en ax el valor de num1
    sub    ax, num2                                                 ;restar num2 a ax
    mov    resta, ax                                                ;almacenar el resultado en resta
EndM
;---Macros para realizar pushAll, popAll---
ListPush Macro lista                                                
    IRP i,<lista>
        Push i
    ENDM
EndM

ListPop Macro lista
    IRP i,<lista>
        Pop i
    ENDM
EndM

PushA Macro
    ListPush <Ax,Bx,Cx,Dx,Si,Di,Bp,Sp>
EndM

PopA Macro
    ListPop <Sp,Bp,Di,Si,Dx,Cx,Bx,Ax>
EndM

;Final