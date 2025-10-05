;Anthony Rodriguez 2021120181
;Calculadora basica que realiza suma, resta, multiplicacion y division de 2 numeros de 3 digitos
;Si el usuario no ingresa algo en linea de comandos se le mostrara un mensaje de ayuda
;Si el usuario ingresa la operacion en linea de comandos se ejecutara la calculadora normalmente

;---------------------------------------------------------
;Para compilar usar:
;1) tener el archivo compilar.bat en la misma carpeta que los archivos .asm
;2) copiar esto en el DosBox: compilar tc7 proc
;3) td tc7 "operacion" (debugear)  o  tc7 "operacion" (ejecutar)
;NOTA: sino agrega la operacion luego del nombre tc7 imprimira el mensaje de ayuda
;--------------------------------------------------------- 
 
;llamadas a procedimientos en proc.asm
include macros.asm
extrn InicializarDS:Far, ClearScreenP:Far, WhereXYP:Far, GotoXYP:Far, PrintCharColorP:Far, PrintCharP:Far, PrintNum:Far, PrintString:Far, ReadKey:Far,WaitKeyP:Far

Pila Segment
         db 64 Dup ('?')
Pila EndS

Datos Segment
    LongLC      EQU 80h
    ayuda       db  10,13,"Por favor ingrese por linea de comandos la operacion que desee realizar, con numeros de maximo 3 cifras y el operando...,",10,13,"Ejemplo: 123 + 456",24h
    errorNum    db  10,13,"Error: Solo se permiten numeros de 3 digitos (000-999)",  10,13,  "Presione cualquier tecla...",24h
    errorOp     db  10,13,"Error: Operando no valido",  10,13,  "Presione cualquier tecla...",24h
    errorDiv    db  10,13,"Error: No se puede dividir por 0",  10,13,  "Presione cualquier tecla...",24h

    ;introduccion de valores y menu
    ;mensajeRep  db 10,13,10,13,"Desea realizar algun otro calculo?",  10,13  ,"1)  SI",  10,13  ,"2)  NO",10,13,24h
    ;mensajeNum  db 10,13,"Digite un numero de 1 digito:       ",24h
    ;mensajeOper db 10,13,10,13,"Que operacion desea realizar?",  10,13  ,"1)  Suma (+)",  10,13  ,"2)  Resta (-)",  10,13  ,"3)  Multiplicacion (*)",  10,13  ,"4)  Division (/)",10,13,24h

    ;impresion de resultados
    RSuma       db  10,13,10,13,"El resultado de la suma es: ",24h
    RResta      db  10,13,10,13,"El resultado de la resta es: ",24h
    RMult       db  10,13,10,13,"El resultado de la multiplicacion es: ",24h
    RDiv        db  10,13,10,13,"El resultado de la division es: ",24h
    RRes        db  10,13,10,13,"El residuo de la division es: ",24h

    ;numeros y variables
    num1        dw  ?                                                                                                                                                                   ;variables para almacenar los numeros ingresados
    num2        dw  ?                                                                                                                                                                   ;variables para almacenar los numeros ingresados
    operando    db  ?,?                                                                                                                                                                 ;variable para almacenar el operando ingresado
    ;var         db ?                           ;variable para almacenar la respuesta de si desea repetir
    cMillar     db  ?                                                                                                                                                                   ;variable para almacenar el digito de las centenas de millar
    dMillar     db  ?                                                                                                                                                                   ;variable para almacenar el digito de las decenas de millar
    uMillar     db  ?                                                                                                                                                                   ;variable para almacenar el digito de las unidades de millar
    c           db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las centenas del num1
    d           db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las decenas del num1
    u           db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las unidades del num1
    c1          db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las centenas del num2
    d1          db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las decenas del num2
    u1          db  ?,?                                                                                                                                                                 ;variable para almacenar el digito de las unidades del num2
    conver1     dw  ?                                                                                                                                                                   ;variable para almacenar las decenas multiplicadas por 10
    conver2     dw  ?                                                                                                                                                                   ;variable para almacenar las centenas multiplicadas por 100

    ;resultados
    suma        dw  ?
    resta       dw  ?
    mult        dw  ?
    bufferDiv   db  '     .    $'                                                                                                                                                       ;buffer para div '    '(entera) '.' (separador) '  ' (decimal)

    ;variables para multiplicacion
    registro    db  ?
    auxiliar    db  ?
    cero        db  ?
    uno         db  ?
    dos         db  ?
    tres        db  ?
    cuatro      db  ?
    cinco       db  ?
    seis        db  ?
    siete       db  ?
    ocho        db  ?
    nueve       db  ?
    diez        db  ?
    once        db  ?

    linecommand db  0FFh Dup (?)                                                                                                                                                        ;variable para almacenar la linea de comandos
    ; mis variables
    validos     db  '0','1','2','3','4','5','6','7','8','9','+','-','*','/',' '
    
Datos EndS

Codigo Segment
                       Assume CS:Codigo, SS:Pila, DS:Datos

    ;rutina para leer linea de comandos
GetCommanderLine Proc Near                                    ;obtiene lo ingresado en linea de comandos y lo pone en var linecommand
    LongLC             EQU    80h
                       mov    bp,sp
                       mov    ax,es
                       mov    ds,ax
                       mov    di,2[bp]
                       mov    ax,4[bp]
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
Print_Num Proc Near
                       mov    di, offset bufferDiv+4          ;puntero al final de la parte entera del buffer
                       mov    cx,0                            ;contador
                       mov    ax,bx                           ;numero a convertir
                       mov    bx,10                           ;divisor para convertir a decimal

    loopNum:           
                       mov    dx,0                            ;extender el dividendo a 32 bits (DX:AX)
                       div    bx                              ;dividir ax entre bx, AX = cociente (parte entera), DX = residuo (parte decimal)
                       add    dx,'0'                          ;convertir el digito a su caracter ASCII
                       mov    [di],dl                         ;guardar el digito en el buffer
                       dec    di                              ;decrementar el puntero al buffer
                       inc    cx                              ;incrementar el contador
                       cmp    ax,0                            ;comparar cociente con 0
                       jne    loopNum                         ;si no, continuar
                       ret
Print_Num EndP

    ;rutina para imprimir la parte fraccionaria del numero
    ;recibe: bx = numero a convertir
    ;retorna nada
Print_Dec Proc Near
                       mov    di, offset bufferDiv+6          ;puntero al final de la parte decimal del buffer
                       mov    ax,bx                           ;numero a convertir
                       mov    bx,10                           ;divisor para convertir a decimal
                       mov    cx,0                            ;contador

    ;imprimir primer decimal
                       mov    dx,0                            ;extender el dividendo a 32 bits (DX:AX)
                       div    bx
                       add    al,'0'
                       mov    [di],al                         ;guardar el digito en el buffer
                       mov    ax,dx                           ;almacenar residuo para siguiente digito
                       inc    di
    ;imprimir segundo decimal
                       add    dl,'0'                          ;segundo decimal a ASCII
                       mov    [di],dl                         ;guardar dìgito en el buffer
                       ret
Print_Dec EndP


Comparaciones Proc near
    ; Comapraciones
                       mov    bp, sp
                       mov    bh, 16[bp]

                       cmp    bh, 9
                       je     centenas1

                       cmp    bh, 8
                       je     decenas1

                       cmp    bh, 7
                       je     unidades1

                       cmp    bh, 5
                       je     op

                       cmp    bh, 3
                       je     centenas2
 
                       cmp    bh, 2
                       je     decenas2

                       cmp    bh, 1
                       je     unidades2
                       jmp    short salida_comparacion

    centenas1:         
                       mov    14[bp],ax
                       sub    14[bp],30h
                       jmp    short salida_comparacion

    decenas1:          
                       mov    12[bp],ax
                       sub    12[bp],30h
                       jmp    short salida_comparacion
    unidades1:         
                       mov    10[bp],ax
                       sub    10[bp],30h
                       jmp    short salida_comparacion

    op:                
                       mov    8[bp],ax
                       jmp    short salida_comparacion
    centenas2:         
                       mov    6[bp],ax
                       sub    6[bp],30h
                       jmp    short salida_comparacion
    decenas2:          
                       mov    4[bp],ax
                       sub    4[bp],30h
                       jmp    short salida_comparacion
    unidades2:         
                       mov    2[bp],ax
                       sub    2[bp],30h
    salida_comparacion:
                       xor    bp,bp
                       ret
Comparaciones endp

    Inicio:            
    ;inicializacion Datos Segment
                       mov    ax,Datos
                       push   ax
                       call   InicializarDS
                       pop    ax

    ;limpiar pantalla y redireccionar cursor
                       mov    bh,0fh                          ;da color blanco a la pantalla
                       xor    cx,cx                           ;pone en 0 ch y cl
                       mov    dh,24                           ;fila inferior
                       mov    dl,79                           ;columna inferior
                       pushA
                       call   ClearScreenP                    ;limpiar pantalla
                       xor    dx,dx                           ;poner en 0 dh y dl para redireccionar cursor a 0,0
                       call   GotoXYP                         ;redireccionar cursor a 0,0

    ;leer linea de comandos
                       push   ds
                       mov    ax,seg linecommand              ;poner en ax el segmento de la variable linecommand
                       push   ax
                       lea    ax,linecommand                  ;poner en ax el offset de la variable linecommand
                       push   ax
                       call   GetCommanderLine
    
    ;mov bh, byte ptr DS:[LongLC]                ;poner en bh el numero de caracteres que tiene la linea de comandos (len)
    ;cmp bh,0                                    ;compara para ver si es vacio
    ;je puente
                       jmp    short calculadora               ;en caso de no ser igual salta a calculadora

    puente:                                                   ;puente para saltar ayuda en caso de ingresar algo en linea de comandos
                       pop    ds
                       jmp    ayudas

    calculadora:       
    ;ajustar es / ds
                       mov    ax,ds                           ;guardar ds en ax
                       mov    es,ax                           ;poner es = ds
                       pop    ds                              ;recuperar ds

    ; Verificar que la línea de comando es válida y clasificar números y operandos
                       mov    di, 82h                         ;para moverse en la línea de comandos dentro del psp
                       mov    cx,9                            ;longitud de la línea de comando

    ; Moverse caracter por caracter en la línea de comandos
    for:               
                       xor    ax,ax
                       mov    al,ES:[di]                      ;caracter que se va a leer
                       push   cx                              ;guarda el contador para el loop principal

    ; verificar que todos los caracteres sean validos
                       mov    cx,15
                       mov    SI, cx
    ; se mueve por la lista de characteres válidos
    chequeo:           
                       dec    SI
                       mov    ah, validos[SI]
                       cmp    al, ah
                       je     salida_chequeo
                       loop   chequeo
                       jmp    puenteAyudas2
    salida_chequeo:    
                       mov    ah,0
                       pop    cx

    ;asigna valores de las variables
                       PUSH   CX
                       push   word ptr c
                       push   word ptr d
                       push   word ptr u
                       push   word ptr operando
                       push   word ptr c1
                       push   word ptr d1
                       push   word ptr u1
                       call   Comparaciones                   ; coloca el valor en la variable correspondiente
                       POP    word ptr u1
                       POP    word ptr d1
                       POP    word ptr c1
                       POP    word ptr operando
                       POP    word ptr u
                       POP    word ptr d
                       POP    word ptr c
                       POP    CX
    salida_for:        
                       inc    di
                       loop   for

                       mov    cx,0                            ;limpiar cx para realizar ajuste
    ajustar:           
                       mov    conver1,0                       ;variable para almacenar las decenas multiplicadas por 10
                       mov    conver2,0                       ;variable para almacenar las centenas multiplicadas por 100
                       cmp    cx,1                            ;comparar si cx es 1 (si ya se ingreso num1)
                       je     ajustarC1                       ;si es 1 saltar a ajustarC1

    ajustarC:          
                       cmp    c,0                             ;comparar si c es 0
                       jz     ajustarD                        ;si es 0 saltar a ajustar d
                       mov    ax,00                           ;limpiar ax
                       mov    al,c                            ;poner en al el valor de c
                       mov    bl,100                          ;poner en bl 100
                       mul    bl                              ;multiplicar al por 100
                       mov    conver1,ax                      ;guardar el resultado en conver1
            
    ajustarD:          
                       cmp    d,0                             ;comparar si d es 0
                       jz     armar1                          ;si es 0 saltar a armar u
                       mov    ax,0                            ;limpiar ax
                       mov    al,d                            ;poner en al el valor de d
                       mov    bl,10                           ;poner en bl 10
                       mul    bl                              ;multiplicar al por 10
                       mov    conver2,ax                      ;mover el resultado a conver2

    armar1:                                                   ;etiqueta para armar num1 tomado de linea de comandos
                       xor    ax,ax                           ;limpiar ax
                       mov    ax,conver1                      ;poner en ax el valor de conver1
                       add    num1,ax                         ;sumar conver1 a num1
                       mov    ax,conver2                      ;poner en ax el valor de conver2
                       add    num1,ax                         ;sumar conver2 a num1
                       mov    al,u                            ;poner en al el valor de u
                       add    num1,ax                         ;sumar u a num1

    ;validar num1
                       cmp    num1,000d                       ;comparar si num1 es menor a 000
                       jl     errorNums                       ;si es menor a 0 saltar a errorNum
                       cmp    num1,999d                       ;comparar si num1 es mayor a 999
                       jg     errorNums                       ;si es mayor a 999 saltar a errorNum
                       mov    cx,1                            ;poner cx en 1 para indicar que ya se ingreso num1
                       jmp    ajustar                         ;si es valido continuar con num2
        
    ajustarC1:         
                       mov    conver1,0                       ;variable para almacenar las decenas multiplicadas por 10
                       mov    conver2,0                       ;variable para almacenar las centenas multiplicadas por 100
                       cmp    c1,0                            ;comparar si c es 0
                       jz     ajustarD1                       ;si es 0 saltar a ajustar d
                       mov    ax,00                           ;limpiar ax
                       mov    al,c1                           ;poner en al el valor de c
                       mov    bl,100                          ;poner en bl 100
                       mul    bl                              ;multiplicar al por 100
                       mov    conver1,ax                      ;guardar el resultado en conver1
            
    ajustarD1:         
                       cmp    d1,0                            ;comparar si d es 0
                       jz     armar2                          ;si es 0 saltar a armar u
                       mov    ax,0                            ;limpiar ax
                       mov    al,d1                           ;poner en al el valor de d
                       mov    bl,10                           ;poner en bl 10
                       mul    bl                              ;multiplicar al por 10
                       mov    conver2,ax                      ;mover el resultado a conver2

    armar2:                                                   ;etiqueta para armar num1 tomado de linea de comandos
                       xor    ax,ax                           ;limpiar ax
                       mov    ax,conver1                      ;poner en ax el valor de conver1
                       add    num2,ax                         ;sumar conver1 a num2
                       mov    ax,conver2                      ;poner en ax el valor de conver2
                       add    num2,ax                         ;sumar conver2 a num2
                       mov    al,u1                           ;poner en al el valor de u
                       add    num2,ax                         ;sumar u a num2

    ;validar num2
                       cmp    num2,000d                       ;comparar si num2 es menor a 0
                       jl     errorNums                       ;si es menor a 000 saltar a errorNum
                       cmp    num2,999d                       ;comparar si num2 es mayor a 999
                       jg     errorNums                       ;si es mayor a 999 saltar a errorNum
                       jmp    short siga1                     ;si es valido continuar

    errorNums:         
                       mov    dx, offset errorNum             ;mensaje de error numero
                       pushA
                       call   PrintString
                       call   WaitKeyP                        ;esperar a que el usuario presione una tecla
                       mov    num1,0                          ;reiniciar num1 en caso de error
                       mov    num2,0                          ;reiniciar num2 en caso de error
                       jmp    ayudas                          ;saltar a ayudas
    puenteAyudas2:     
                       jmp    puenteAyudas

    siga1:                                                    ;etiqueta para leer y comparar operando
    ;leer operando
                       xor    bp,bp                           ;limpiar registro bp

    ;comparar operando
                       cmp    operando,"+"                    ;comparar si es +
                       je     sumaOp                          ;si es + saltar a sumaOp
                       cmp    operando,"-"                    ;comparar si es -
                       je     puenteRes                       ;si es - saltar a restaOp
                       cmp    operando,"*"                    ;comparar si es *
                       je     puenteMult                      ;si es * saltar a puenteMult
                       cmp    operando,"/"                    ;comparar si es /
                       je     puenteDiv                       ;si es / saltar a divOp
                       jmp    short errorOper                 ;si no es ninguno de los 4 saltar a inicio

    errorOper:         
                       mov    dx, offset errorOp              ;mensaje de error operando
                       pushA
                       call   PrintString
                       call   WaitKeyP                        ;esperar a que el usuario presione una tecla
                       mov    operando,0                      ;reiniciar operando en caso de error
                       jmp    short puenteAyudas              ;saltar a ayudas

    sumaOp:            
                       xor    ax,ax                           ;limpiar ax
                       xor    bx,bx                           ;limpiar bx
                       mov    ax, num1                        ;poner en ax el valor de num1
                       add    suma, ax                        ;sumar num1 a suma
                       mov    ax, num2                        ;poner en ax el valor de num2
                       add    suma, ax                        ;sumar num2 a suma
                       jmp    short sigaSuma

    puenteRes:         
                       jmp    restaOp                         ;saltar a restaOp
    puenteMult:        
                       jmp    puenteMult1                     ;saltar a multOp
    puenteDiv:         
                       jmp    puenteDiv1                      ;saltar a divOp
            
    sigaSuma:          
    ;imprimir resultado
                       mov    dx, offset RSuma                ;mensaje de resultado suma
                       pushA
                       call   PrintString
                       xor    ax,ax                           ;limpiar ax
                       mov    ax, suma                        ;poner en ax el valor de suma
                       mov    dl,10                           ;poner en dl 10 para ajustar
                       div    dl                              ;separar unidades
                       mov    u,ah                            ;guardar unidades en u
                       mov    ah,00h                          ;limpiar ah
                       div    dl                              ;separar decenas y centenas
                       mov    d,ah                            ;guardar decenas en d
                       mov    ah,00h                          ;limpiar ah
                       div    dl                              ;separar centenas y uMillar
                       mov    c,ah                            ;guardar centenas en c
                       mov    uMillar,al                      ;guardar miles en uMillar
                       push   word ptr uMillar                ;reservar espacio en la pila para uMillar
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr c                      ;reservar espacio en la pila para c
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr d                      ;reservar espacio en la pila para d
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr u                      ;reservar espacio en la pila para u
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       jmp    short puenteSalir1              ;saltar a salir

    puenteAyudas:      
                       jmp    puenteAyudas1                   ;saltar a ayudas

    restaOp:           
                       xor    ax,ax                           ;limpiar ax
                       mov    ax, num1                        ;poner en ax el valor de num1
                       sub    ax, num2                        ;restar num2 a ax
                       mov    resta, ax                       ;almacenar el resultado en resta

    ;imprimir resultado
                       mov    dx, offset RResta               ;mensaje de resultado resta
                       pushA
                       call   PrintString
                       mov    ax, resta                       ;poner en ax el valor de resta
                       cmp    ax,0                            ;comparar si el resultado es negativo
                       jge    positivo                        ;si es mayor o igual a 0 saltar a positivo
                       xor    dx,dx                           ;limpiar dx para hacer la negacion
                       mov    dl,'-'                          ;poner en dl el signo negativo
                       push   dx                              ;pasar el signo negativo por pila
                       call   PrintCharP                      ;llamar a PrintCharP para imprimir el signo negativo
                       pop    dx
                       mov    ax,resta
                       neg    ax                              ;hacer positivo el valor de ax
                       jmp    short positivo

    puenteMult1:       
                       jmp    multOp                          ;saltar a multOp

    positivo:          
                       mov    dl,10                           ;poner en dl 10 para ajustar
                       div    dl                              ;separar unidades
                       mov    u,ah                            ;guardar unidades en u
                       mov    ah,00h                          ;limpiar ah
                       div    dl                              ;separar decenas y centenas
                       mov    d,ah                            ;guardar decenas en d
                       mov    ah,00h                          ;limpiar ah
                       div    dl                              ;separar centenas y uMillar
                       mov    c,ah                            ;guardar centenas en c
                       mov    uMillar,al                      ;guardar miles en uMillar
                       push   word ptr uMillar                ;reservar espacio en la pila para uMillar
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr c                      ;reservar espacio en la pila para c
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr d                      ;reservar espacio en la pila para d
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr u                      ;reservar espacio en la pila para u
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       jmp    short puenteSalir1              ;saltar a salir

    puenteSalir1:      
                       jmp    puenteSalir2                    ;saltar a salir
    puenteDiv1:        
                       jmp    divOp                           ;saltar a divOp
    puenteAyudas1:     
                       jmp    ayudas                          ;saltar a ayudas


    multOp:            
                       xor    ax,ax                           ;limpiar ax
                       xor    bx,bx
    ;multiplicar u por u1
                       mov    al,u                            ;unidades num1 en al
                       mov    bl,u1                           ;unidades num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desenpaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    cero,al                         ;guardar resultado de unidades en cero
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d por u1
                       mov    al,d                            ;decenas num1 en al
                       mov    bl,u1                           ;unidades num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al (sumar el carry anterior)
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    uno,al                          ;guardar resultado de unidades en uno
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c por u1
                       mov    al,c                            ;centenas num1 en al
                       mov    bl,u1                           ;unidades num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    dos,al                          ;guardar resultado de unidades en dos
                       mov    tres,ah                         ;guardar el resultado de decenas en tres (carry)
    ;multiplicar u con d1
                       mov    al,u                            ;unidades num1 en al
                       mov    bl,d1                           ;decenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    cuatro,al                       ;guardar resultado de unidades en cuatro
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d con d1
                       mov    al,d                            ;decenas num1 en al
                       mov    bl,d1                           ;decenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    cinco,al                        ;guardar resultado de unidades en cinco
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c con d1
                       mov    al,c                            ;centenas num1 en al
                       mov    bl,d1                           ;decenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    seis,al                         ;guardar resultado de unidades en seis
                       mov    siete,ah                        ;guardar el resultado de decenas en siete (carry)
    ;multiplicar u con c1
                       mov    al,u                            ;unidades num1 en al
                       mov    bl,c1                           ;centenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    ocho,al                         ;guardar resultado de unidades en ocho
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar d con c1
                       mov    al,d                            ;decenas num1 en al
                       mov    bl,c1                           ;centenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    nueve,al                        ;guardar resultado de unidades en nueve
                       mov    auxiliar,ah                     ;guardar el resultado de decenas en auxiliar (carry)
    ;multiplicar c con c1
                       mov    al,c                            ;centenas num1 en al
                       mov    bl,c1                           ;centenas num2 en bl
                       mul    bl                              ;multiplicar al por bl
                       add    al,auxiliar                     ;sumar auxiliar a al
                       mov    registro,al                     ;almacenar decenas de resultado en registro
    ;desempaquetar registro
                       mov    al,registro                     ;guardar registro en al
                       aam                                    ;ajustar ax para separar decenas y unidades
                       mov    diez,al                         ;guardar resultado de unidades en diez
                       mov    once,ah                         ;guardar el resultado de decenas en once (carry)
    ;sumamos resultados
                       mov    al,uno                          ;almacenar uno en al
                       add    al,cuatro                       ;sumar al con cuatro
                       aam                                    ;separar decenas y unidades de resultado
                       mov    uno,al                          ;decenas en uno (resultado final)
                       mov    auxiliar,ah                     ;decenas en auxiliar (carry)
                       mov    al,dos                          ;almacenar dos en al
                       add    al,cinco                        ;sumar al con cinco
                       add    al,ocho                         ;sumar al con ocho
                       add    al,auxiliar                     ;sumar al con auxiliar (carry)
                       aam                                    ;separar decenas y unidades de resultado
                       mov    dos,al                          ;centenas en dos (resultado final)
                       mov    auxiliar,ah                     ;decenas en auxiliar (carry)
                       mov    al,tres                         ;almacenar tres en al
                       add    al,seis                         ;sumar al con seis
                       add    al,nueve                        ;sumar al con nueve
                       add    al,auxiliar                     ;sumar al con auxiliar (carry)
                       aam                                    ;separar decenas y unidades de resultado
                       mov    tres,al                         ;decenas en tres (resultado final)
                       mov    auxiliar,ah                     ;decenas en auxiliar (carry)
                       mov    al,siete                        ;almacenar siete en al
                       add    al,diez                         ;sumar al con diez
                       add    al,auxiliar                     ;sumar al con auxiliar (carry)
                       aam                                    ;separar decenas y unidades de resultado
                       mov    siete,al                        ;centenas en siete (resultado final)
                       mov    auxiliar,ah                     ;decenas en auxiliar (carry)
                       mov    al,once                         ;almacenar once en al
                       add    al,auxiliar                     ;sumar al con auxiliar (carry)
                       mov    once,al                         ;decenas en once (resultado final)

    ;imprimir resultado
                       mov    dx, offset RMult                ;mensaje de resultado multiplicacion
                       pushA
                       call   PrintString
                       mov    ax, mult                        ;poner en ax el valor de mult
                       push   word ptr once                   ;reservar espacio en la pila para cMillar
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr siete                  ;reservar espacio en la pila para dMillar
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr tres                   ;reservar espacio en la pila para uMillar
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr dos                    ;reservar espacio en la pila para centenas
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr uno                    ;reservar espacio en la pila para decenas
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       push   word ptr cero                   ;reservar espacio en la pila para unidades
                       call   PrintNum                        ;llamar a PrintNum para imprimir el resultado
                       jmp    short puenteSalir2              ;saltar a salir

    puenteSalir2:      
                       jmp    puenteSalir                     ;saltar a salir

    divOp:             
    ;division obtener parte entera
                       xor    ax,ax                           ;limpiar ax
                       xor    bx,bx                           ;limpiar bx
                       mov    ax,num1                         ;poner en ax el valor de num1
                       mov    dx,0                            ;extender el dividendo a 32 bits (DX:AX)
                       mov    cx,num2                         ;poner en cx el valor de num2
                       cmp    cx,0                            ;comparar si num2 es 0 para evitar division por 0
                       je     error                           ;si es 0 saltar a error
                       div    cx                              ;dividir ax entre cx, AX = cociente (parte entera), DX = residuo (parte decimal)
            
    ;almacenar la parte entera en el buffer
                       mov    bx,ax
                       push   dx                              ; guardar el residuo en la pila
                       call   print_num
                       pop    dx                              ;recuperar el residuo

    ;calcular la parte fraccionaria (2 decimales)
                       mov    ax,dx                           ;mover el residuo de la division a ax
                       mov    cx,100                          ;multiplicar por 100 para obtener 2 decimales
                       mul    cx                              ;ax * 100. resultado de 16*16 bits va a DX:AX
                       mov    cx,num2                         ;poner en cx el valor de num2 (divisor)
                       div    cx                              ;dividir DX:AX por cx
    ;resultado: AX = parte decimal, DX = residuo
            
    ;almacenar la parte fraccionaria en el buffer
                       mov    bx,ax
                       call   print_dec                       ;imprimir decimales

    ;impresion resultado
                       mov    dx, offset RDiv                 ;mensaje de resultado division
                       pushA
                       call   PrintString
                       mov    dx,offset bufferDiv
                       pushA
                       call   PrintString
                       jmp    short puenteSalir               ;saltar a salir

    error:             
                       mov    dx, offset errorDiv             ;mensaje de error division por 0
                       pushA
                       call   PrintString
                       call   WaitKeyP                        ;esperar a que el usuario presione una tecla

    ;final
    puenteSalir:       
                       jmp    short salga                     ;saltar a salida del programa


    ayudas:            
                       mov    bh,0fh                          ;da color blanco a la pantalla
                       xor    cx,cx                           ;pone en 0 ch y cl
                       mov    dh,24                           ;fila inferior
                       mov    dl,79                           ;columna inferior
                       pushA
                       call   ClearScreenP
                       xor    dx,dx                           ;poner en 0 dh y dl para redireccionar cursor a 0,0
                       call   GotoXYP
                       mov    dx,offset ayuda                 ;mensaje de ayuda
                       pushA
                       call   PrintString

    Salga:             
                       mov    ax,4c00h                        ;codigo para terminar el programa
                       int    21h

Codigo EndS
    End Inicio
