;Libreria de procedimientos
Procedimientos Segment
    ;aca proc debe ser far

                        public InicializarDS, ClearScreenP, WhereXYP, GotoXYP, PrintCharColorP, PrintCharP, PrintNum, PrintString, ReadKey, WaitKeyP, GetCommanderLine, print_num, print_dec, ConversionNum, ArmarP, SUmaP, ImprimirResultadoSR, RestaP, MultiplicarP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal
    ;debe mandar en el ax el segmento de datos
    ;ej
    ;{ mov ax,Datos
    ;  push ax
    ;  call InicializarDS
    ;---------------------------------------------------------
InicializarDS Proc Far
                        xor    ax,ax
                        mov    bp,sp
                        mov    ax,4[bp]
                        mov    ds,ax
                        RetF
InicializarDS EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal
    ;debe mandar en el bh (atributo),ch (fila inferior),
    ;cl (columna inferior),dh (fila superior),dl (columna superior)
    ;y posterior un pushA
    ;ej
    ;{   mov bh,0fh
    ;    xor cx,cx
    ;    mov dh,24
    ;    mov dl,79
    ;    pushA
    ;    call ClearScreenP
    ;---------------------------------------------------------
ClearScreenP Proc Far
                        mov    ah,07h
                        xor    al,al
                        int    10h
                        RetF   8*2
ClearScreenP EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;realizar un push word ptr "var" variable donde se quiere
    ;poner el numero de fila y otro para el numero de columna
    ;despues del call un pop word ptr "var" para la fila y
    ;otro para la comlumna
    ;---------------------------------------------------------
WhereXYP Proc Far
                        mov    ah,03h
                        xor    bh,bh
                        mov    bp,sp
                        int    10h
                        mov    6[bp],dh                                                                                                                                                                                                                                  ;poner en "fila" el valor de la fila retornado
                        mov    4[bp],dl                                                                                                                                                                                                                                  ;poner en "columna" el valor de la columna retornado
                        RetF
WhereXYP EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;dh (fila) , dl (columna) a poner el cursor
    ;ej
    ;{ xor dx,dx
    ;  call GotoXYP
    ;---------------------------------------------------------
GotoXYP Proc Far
                        mov    ah,02h
                        xor    bh,bh
                        int    10h
                        RetF
GotoXYP EndP

    ;--------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;al= caracter a imprimir, bl= color del caracter,
    ;cx= cantidad de caracteres a imprimir (pasar por pila)
PrintCharColorP Proc Far
                        mov    ah,09h
                        xor    bh,bh
                        mov    cx,4[bp]
                        int    10h
                        RetF
PrintCharColorP EndP

    ;--------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;poner en el dl el caracter a imprimir
PrintCharP Proc Far
                        mov    bp,sp
                        mov    ah,02h
                        mov    dl,4[bp]
                        int    21h
                        RetF
PrintCharP EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal
    ;debe mandar en el dx la var a imprimir con $ al final
    ;y posterior un pushA
    ;ej
    ;{   mov dx,offset enter
    ;    pushA
    ;    call PrintString
    ;---------------------------------------------------------
PrintString Proc Far
                        mov    ah,09h
                        int    21h
                        RetF   8*2
PrintString EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;enviar por pila en dl el num a imprimir
    ;num debe venir en forma decimal, es decir con un signo ASCII
    ;ejem: 5 es un trebol, ya que el 5 de consola entra como 35h
    ;y eso nos da un 5 en decimal restandole 30h
PrintNum Proc Far
                        mov    bp,sp
                        mov    ah,02h
                        mov    dl,4[bp]
                        add    dl,30h
                        int    21h
                        RetF   2
PrintNum EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;realizar un push word ptr "var" variable donde se quiere
    ;poner el caracter ingresado, posterior un pushA
    ;al final despues de la llamada a este se debe hacer un
    ;pop word ptr "var"
    ;ej
    ;{  push word ptr num1
    ;   pushA
    ;   call ReadKey
    ;   pop word ptr num1
    ;   xor bp,bp
    ;---------------------------------------------------------
ReadKey Proc Far
                        mov    bp,sp
                        mov    ah,01h
                        int    21h
                        mov    12h[bp],al
                        RetF   7*2
ReadKey EndP

WaitKeyP Proc Far
                        mov    ah,01h
                        int    21h
                        RetF
WaitKeyP EndP

    ; --Procedimientos proyecto 1--
    ;obtiene lo ingresado en linea de comandos y lo pone en var linecommand
GetCommanderLine Proc Far
    LongLC              EQU    80h
                        mov    bp,sp
                        mov    ax,es
                        mov    ds,ax
                        mov    di,4[bp]
                        mov    ax,6[bp]
                        mov    es,ax
                        xor    cx,cx
                        mov    cl,Byte ptr DS:[LongLC]
                        dec    cl
                        mov    si,2[LongLC]
                        cld
                        rep    movsb
                        ret    2*2
GetCommanderLine EndP



    ;rutina para imprimir la parte entera del numero
    ;recibe: bx = numero a convertir
    ;retorna nada
Print_Num Proc far
                        mov    bp, sp
                        mov    di, 8[bp]                                                                                                                                                                                                                                 ;buffer de división
                        mov    ax, 6[bp]                                                                                                                                                                                                                                 ;numero a convertir
                        mov    bx,10                                                                                                                                                                                                                                     ;divisor para convertir a decimal
                        xor    dx,dx                                                                                                                                                                                                                                     ;extender el dividendo a 32 bits (DX:AX)
                        div    bx                                                                                                                                                                                                                                        ;dividir ax entre bx, AX = cociente (parte entera), DX = residuo (parte decimal)
                        add    dx,'0'                                                                                                                                                                                                                                    ;convertir el digito a su caracter ASCII
                        mov    [di],dl                                                                                                                                                                                                                                   ;guardar el digito en el buffer
                        dec    di                                                                                                                                                                                                                                        ;decrementar el puntero al buffer
                        mov    8[bp],di                                                                                                                                                                                                                                  ;buffer de división
                        mov    6[bp], ax                                                                                                                                                                                                                                 ;numero a convertir

                        xor    bp,bp
                        retf
Print_Num EndP

    ;rutina para imprimir la parte fraccionaria del numero
    ;recibe: bx = numero a convertir
    ;retorna nada
Print_Dec Proc far
                        mov    bp,sp
                        mov    di,6[bp]
                        mov    ax,4[bp]                                                                                                                                                                                                                                  ;numero a convertir
                        mov    bx,10                                                                                                                                                                                                                                     ;divisor para convertir a decimal

    ;Primer decimal
                        mov    dx,0                                                                                                                                                                                                                                      ;extender el dividendo a 32 bits (DX:AX)
                        div    bx
                        add    al,'0'
                        mov    [di],al                                                                                                                                                                                                                                   ;guardar el digito en el buffer
                        mov    ax,dx                                                                                                                                                                                                                                     ;almacenar residuo para siguiente digito
                        inc    di
    ;Segundo decimal
                        add    dl,'0'                                                                                                                                                                                                                                    ;segundo decimal a ASCII
                        mov    [di],dl                                                                                                                                                                                                                                   ;guardar dìgito en el buffer
                        retf
Print_Dec EndP

    ;Convierte el caracter ASCII que se le pase en número, si es posible
ConversionNum Proc far
                        mov    bp,sp
                        mov    4[bp], ax
                        sub    4[bp], 30h
                        xor    bp,bp
                        retf
ConversionNum endp

ArmarP Proc Far
                        mov    bp,sp
                        xor    ax,ax                                                                                                                                                                                                                                     ;limpiar ax
                        mov    ax,8[bp]                                                                                                                                                                                                                                  ;poner en ax el valor de conver1
                        add    10[bp],ax                                                                                                                                                                                                                                 ;sumar conver1 a la suma
                        mov    ax,6[bp]                                                                                                                                                                                                                                  ;poner en ax el valor de conver2
                        add    10[bp],ax                                                                                                                                                                                                                                 ;sumar conver2 a suma
                        mov    al,4[bp]                                                                                                                                                                                                                                  ;poner en al el valor de u
                        add    10[bp],ax                                                                                                                                                                                                                                 ;sumar u a suma
                        xor    bp,bp
                        retf   6
ArmarP EndP

SumaP Proc Far
                        mov    bp, sp
                        xor    ax,ax                                                                                                                                                                                                                                     ;limpiar ax
                        mov    ax, 4[bp]                                                                                                                                                                                                                                 ;poner en ax el valor de num2
                        add    8[bp], ax                                                                                                                                                                                                                                 ;sumar num1 a suma
                        mov    ax, 6[bp]                                                                                                                                                                                                                                 ;poner en ax el valor de num1
                        add    8[bp], ax                                                                                                                                                                                                                                 ;sumar num2 a suma
                        xor    bp,bp
                        retf   4
SumaP EndP

    ; Imprimr resulado para suma y resta
ImprimirResultadoSR Proc Far
                        mov    bp, sp
                        xor    ax,ax                                                                                                                                                                                                                                     ;limpiar ax
                        mov    ax, 12[bp]                                                                                                                                                                                                                                ;poner en ax el valor de suma
                        mov    dl,10                                                                                                                                                                                                                                     ;poner en dl 10 para ajustar
                        div    dl                                                                                                                                                                                                                                        ;separar unidades
                        mov    4[bp],ah                                                                                                                                                                                                                                  ;guardar unidades en u
                        mov    ah,00h                                                                                                                                                                                                                                    ;limpiar ah
                        div    dl                                                                                                                                                                                                                                        ;separar decenas y centenas
                        mov    6[bp],ah                                                                                                                                                                                                                                  ;guardar decenas en d
                        mov    ah,00h                                                                                                                                                                                                                                    ;limpiar ah
                        div    dl                                                                                                                                                                                                                                        ;separar centenas y uMillar
                        mov    8[bp],ah                                                                                                                                                                                                                                  ;guardar centenas en c
                        mov    10[bp],al                                                                                                                                                                                                                                 ;guardar miles en uMillar
                        push   10[bp]                                                                                                                                                                                                                                    ;reservar espacio en la pila para uMillar
                        call   PrintNum                                                                                                                                                                                                                                  ;llamar a PrintNum para imprimir el resultado
                        xor    bp,bp
                        mov    bp,sp
                        push   8[bp]                                                                                                                                                                                                                                     ;reservar espacio en la pila para c
                        call   PrintNum                                                                                                                                                                                                                                  ;llamar a PrintNum para imprimir el resultado

                        xor    bp,bp
                        mov    bp,sp
                        push   6[bp]                                                                                                                                                                                                                                     ;reservar espacio en la pila para d
                        call   PrintNum                                                                                                                                                                                                                                  ;llamar a PrintNum para imprimir el resultado

                        xor    bp,bp
                        mov    bp,sp
                        push   4[bp]                                                                                                                                                                                                                                     ;reservar espacio en la pila para u
                        call   PrintNum                                                                                                                                                                                                                                  ;llamar a PrintNum para imprimir el resultado
                        xor    bp,bp
                        retf   10
ImprimirResultadoSR EndP

    ; Procedimeinto de resta de dos numeros de tres digitos
RestaP Proc Far
                        mov    bp,sp
                        xor    ax,ax                                                                                                                                                                                                                                     ;limpiar ax
                        mov    ax, 6[bp]                                                                                                                                                                                                                                 ;poner en ax el valor de num1
                        sub    ax, 4[bp]                                                                                                                                                                                                                                 ;restar num2 a ax
                        mov    8[bp], ax                                                                                                                                                                                                                                 ;almacenar el resultado en resta
                        xor    bp,bp
                        retf   4
RestaP EndP

MultiplicarP Proc Far
                        push   bp
                        mov    bp, sp

    ; Parámetros en pila:
    ; 44[bp] - u
    ; 42[bp] - d
    ; 40[bp] - c
    ; 38[bp] - u1
    ; 36[bp] - d1
    ; 34[bp] - c1
    ; 32[bp] - registro
    ; 30[bp] - auxiliar
    ; 28[bp] - cero
    ; 26[bp] - uno
    ; 24[bp] - dos
    ; 22[bp] - tres
    ; 20[bp] - cuatro
    ; 18[bp] - cinco
    ; 16[bp] - seis
    ; 14[bp] - siete
    ; 12[bp] - ocho
    ; 10[bp] - nueve
    ; 8[bp]  - diez
    ; 6[bp]  - once

                        xor    ax, ax                                                                                                                                                                                                                                    ;limpiar ax
                        xor    bx, bx                                                                                                                                                                                                                                    ;limpiar bx
    
    ;multiplicar u por u1
                        mov    al, byte ptr 44[bp]                                                                                                                                                                                                                       ;unidades num1 en al
                        mov    bl, byte ptr 38[bp]                                                                                                                                                                                                                       ;unidades num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desenpaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 28[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en cero
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar d por u1
                        mov    al, byte ptr 42[bp]                                                                                                                                                                                                                       ;decenas num1 en al
                        mov    bl, byte ptr 38[bp]                                                                                                                                                                                                                       ;unidades num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al (sumar el carry anterior)
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 26[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en uno
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar c por u1
                        mov    al, byte ptr 40[bp]                                                                                                                                                                                                                       ;centenas num1 en al
                        mov    bl, byte ptr 38[bp]                                                                                                                                                                                                                       ;unidades num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 24[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en dos
                        mov    [di], al
                        mov    di, 22[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en tres (carry)
                        mov    [di], ah
    
    ;multiplicar u con d1
                        mov    al, byte ptr 44[bp]                                                                                                                                                                                                                       ;unidades num1 en al
                        mov    bl, byte ptr 36[bp]                                                                                                                                                                                                                       ;decenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 20[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en cuatro
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar d con d1
                        mov    al, byte ptr 42[bp]                                                                                                                                                                                                                       ;decenas num1 en al
                        mov    bl, byte ptr 36[bp]                                                                                                                                                                                                                       ;decenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 18[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en cinco
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar c con d1
                        mov    al, byte ptr 40[bp]                                                                                                                                                                                                                       ;centenas num1 en al
                        mov    bl, byte ptr 36[bp]                                                                                                                                                                                                                       ;decenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 16[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en seis
                        mov    [di], al
                        mov    di, 14[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en siete (carry)
                        mov    [di], ah
    
    ;multiplicar u con c1
                        mov    al, byte ptr 44[bp]                                                                                                                                                                                                                       ;unidades num1 en al
                        mov    bl, byte ptr 34[bp]                                                                                                                                                                                                                       ;centenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 12[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en ocho
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar d con c1
                        mov    al, byte ptr 42[bp]                                                                                                                                                                                                                       ;decenas num1 en al
                        mov    bl, byte ptr 34[bp]                                                                                                                                                                                                                       ;centenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 10[bp]                                                                                                                                                                                                                                ;guardar resultado de unidades en nueve
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;guardar el resultado de decenas en auxiliar (carry)
                        mov    [di], ah
    
    ;multiplicar c con c1
                        mov    al, byte ptr 40[bp]                                                                                                                                                                                                                       ;centenas num1 en al
                        mov    bl, byte ptr 34[bp]                                                                                                                                                                                                                       ;centenas num2 en bl
                        mul    bl                                                                                                                                                                                                                                        ;multiplicar al por bl
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar auxiliar a al
                        add    al, [di]
                        mov    di, 32[bp]                                                                                                                                                                                                                                ;almacenar decenas de resultado en registro
                        mov    [di], al
    
    ;desempaquetar registro
                        mov    al, [di]                                                                                                                                                                                                                                  ;guardar registro en al
                        aam                                                                                                                                                                                                                                              ;ajustar ax para separar decenas y unidades
                        mov    di, 8[bp]                                                                                                                                                                                                                                 ;guardar resultado de unidades en diez
                        mov    [di], al
                        mov    di, 6[bp]                                                                                                                                                                                                                                 ;guardar el resultado de decenas en once (carry)
                        mov    [di], ah
    
    ;sumamos resultados
                        mov    di, 26[bp]                                                                                                                                                                                                                                ;almacenar uno en al
                        mov    al, [di]
                        mov    di, 20[bp]                                                                                                                                                                                                                                ;sumar al con cuatro
                        add    al, [di]
                        aam                                                                                                                                                                                                                                              ;separar decenas y unidades de resultado
                        mov    di, 26[bp]                                                                                                                                                                                                                                ;decenas en uno (resultado final)
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;decenas en auxiliar (carry)
                        mov    [di], ah
    
                        mov    di, 24[bp]                                                                                                                                                                                                                                ;almacenar dos en al
                        mov    al, [di]
                        mov    di, 18[bp]                                                                                                                                                                                                                                ;sumar al con cinco
                        add    al, [di]
                        mov    di, 12[bp]                                                                                                                                                                                                                                ;sumar al con ocho
                        add    al, [di]
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar al con auxiliar (carry)
                        add    al, [di]
                        aam                                                                                                                                                                                                                                              ;separar decenas y unidades de resultado
                        mov    di, 24[bp]                                                                                                                                                                                                                                ;centenas en dos (resultado final)
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;decenas en auxiliar (carry)
                        mov    [di], ah
    
                        mov    di, 22[bp]                                                                                                                                                                                                                                ;almacenar tres en al
                        mov    al, [di]
                        mov    di, 16[bp]                                                                                                                                                                                                                                ;sumar al con seis
                        add    al, [di]
                        mov    di, 10[bp]                                                                                                                                                                                                                                ;sumar al con nueve
                        add    al, [di]
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar al con auxiliar (carry)
                        add    al, [di]
                        aam                                                                                                                                                                                                                                              ;separar decenas y unidades de resultado
                        mov    di, 22[bp]                                                                                                                                                                                                                                ;decenas en tres (resultado final)
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;decenas en auxiliar (carry)
                        mov    [di], ah
    
                        mov    di, 14[bp]                                                                                                                                                                                                                                ;almacenar siete en al
                        mov    al, [di]
                        mov    di, 8[bp]                                                                                                                                                                                                                                 ;sumar al con diez
                        add    al, [di]
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar al con auxiliar (carry)
                        add    al, [di]
                        aam                                                                                                                                                                                                                                              ;separar decenas y unidades de resultado
                        mov    di, 14[bp]                                                                                                                                                                                                                                ;centenas en siete (resultado final)
                        mov    [di], al
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;decenas en auxiliar (carry)
                        mov    [di], ah
    
                        mov    di, 6[bp]                                                                                                                                                                                                                                 ;almacenar once en al
                        mov    al, [di]
                        mov    di, 30[bp]                                                                                                                                                                                                                                ;sumar al con auxiliar (carry)
                        add    al, [di]
                        mov    di, 6[bp]                                                                                                                                                                                                                                 ;decenas en once (resultado final)
                        mov    [di], al

                        pop    bp
                        xor    bp, bp
                        retf   40
MultiplicarP EndP

Procedimientos EndS
    End