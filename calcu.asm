;Anthony Rodriguez 2021120181, Esteban Azofeifa 2023113603
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
 
;llamadas a procedimientos en proc.asm e include
include macroC.asm
extrn InicializarDS:Far, ClearScreenP:Far, WhereXYP:Far, GotoXYP:Far, PrintCharColorP:Far, PrintCharP:Far, PrintNum:Far, PrintString:Far, ReadKey:Far,WaitKeyP:Far,GetCommanderLine:Far, Print_Num:Far, Print_Dec:far, ConversionNum:Far, ArmarP:Far, SumaP:Far, ImprimirResultadoSR:Far, RestaP:Far

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
    num1        dw  ?                                                                                       ;variables para almacenar los numeros ingresados
    num2        dw  ?                                                                                       ;variables para almacenar los numeros ingresados
    operando    db  ?,?                                                                                     ;variable para almacenar el operando ingresado
    ;var         db ?                           ;variable para almacenar la respuesta de si desea repetir 
    cMillar     db  ?                                                                                       ;variable para almacenar el digito de las centenas de millar
    dMillar     db  ?                                                                                       ;variable para almacenar el digito de las decenas de millar
    uMillar     db  ?                                                                                       ;variable para almacenar el digito de las unidades de millar
    c           db  ?,?                                                                                     ;variable para almacenar el digito de las centenas del num1
    d           db  ?,?                                                                                     ;variable para almacenar el digito de las decenas del num1
    u           db  ?,?                                                                                     ;variable para almacenar el digito de las unidades del num1
    c1          db  ?,?                                                                                     ;variable para almacenar el digito de las centenas del num2
    d1          db  ?,?                                                                                     ;variable para almacenar el digito de las decenas del num2
    u1          db  ?,?                                                                                     ;variable para almacenar el digito de las unidades del num2
    conver1     dw  ?                                                                                       ;variable para almacenar las decenas multiplicadas por 10
    conver2     dw  ?                                                                                       ;variable para almacenar las centenas multiplicadas por 100

    ;resultados
    suma        dw  ?
    resta       dw  ?
    mult        dw  ?
    bufferDiv   db  '     .    $'                                                                           ;buffer para div '    '(entera) '.' (separador) '  ' (decimal)

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

    linecommand db  0FFh Dup (?)                                                                            ;variable para almacenar la linea de comandos

    validos     db  '0','1','2','3','4','5','6','7','8','9','+','-','*','/',' '
    
Datos EndS

Codigo Segment
    Assume      CS:Codigo, SS:Pila, DS:Datos



    Inicio:        
    ;inicializacion Datos Segment
        mov         ax,Datos
        push        ax
        call        InicializarDS
        pop         ax

    ;limpiar pantalla y redireccionar cursor
        mov         bh,0fh                                                                                  ;da color blanco a la pantalla
        xor         cx,cx                                                                                   ;pone en 0 ch y cl
        mov         dh,24                                                                                   ;fila inferior
        mov         dl,79                                                                                   ;columna inferior
        pushA
        call        ClearScreenP                                                                            ;limpiar pantalla
        xor         dx,dx                                                                                   ;poner en 0 dh y dl para redireccionar cursor a 0,0
        call        GotoXYP                                                                                 ;redireccionar cursor a 0,0

    ; Verificar que la línea de comandos tenga 9 caracteres
        mov         di, 80h
        xor         ax,ax
        mov         al, ES:[di]
        cmp         ax,10
        jne         puenteAyudas3
    

    ;leer linea de comandos
        push        ds
        mov         ax,seg linecommand                                                                      ;poner en ax el segmento de la variable linecommand
        push        ax
        lea         ax,linecommand                                                                          ;poner en ax el offset de la variable linecommand
        push        ax
        call        GetCommanderLine
    
    calculadora:   
    ;ajustar es / ds
        mov         ax,ds                                                                                   ;guardar ds en ax
        mov         es,ax                                                                                   ;poner es = ds
        pop         ds                                                                                      ;recuperar ds

    ; Verificar que la línea de comando es válida y clasificar números y operandos
        mov         di, 82h                                                                                 ;para moverse en la línea de comandos dentro del psp
        mov         cx,9                                                                                    ;longitud de la línea de comando

    ; Moverse caracter por caracter en la línea de comandos
    for:           
        xor         ax,ax
        mov         al,ES:[di]                                                                              ;caracter que se va a leer
        push        cx                                                                                      ;guarda el contador para el loop principal

    ; verificar que todos los caracteres sean validos
        mov         cx,15
        mov         SI, cx

    ; se mueve por la lista de characteres válidos
    chequeo:       
        dec         SI
        mov         ah, validos[SI]
        cmp         al, ah
        je          salida_chequeo
        loop        chequeo
        jmp         puenteAyudas2
    salida_chequeo:
        mov         ah,0
        pop         cx

    ;asigna valores de las variables
    ;PUSH   CX
        cmp         cx, 9
        je          centenas1
        cmp         cx, 8
        je          decenas1
        cmp         cx, 7
        je          unidades1
        cmp         cx, 5
        je          op
        cmp         cx, 3
        je          centenas2
        cmp         cx, 2
        je          decenas2
        cmp         cx, 1
        je          unidades2
        jmp         short salida_for
                   
puenteAyudas3: 
    jmp         puenteAyudas

    for_puente:    
        jmp         short for
    centenas1:     
        push        word ptr c
        call        ConversionNum
        pop         word ptr c
        jmp         short salida_for
    decenas1:      
        push        word ptr d
        call        ConversionNum
        pop         word ptr d
        jmp         short salida_for
    unidades1:     
        push        word ptr u
        call        ConversionNum
        pop         word ptr u
        jmp         short salida_for
    op:            
        mov         operando, al
        jmp         short salida_for
    centenas2:     
        push        word ptr c1
        call        ConversionNum
        pop         word ptr c1
        jmp         short salida_for
    decenas2:      
        push        word ptr d1
        call        ConversionNum
        pop         word ptr d1
        jmp         short salida_for
    unidades2:     
        push        word ptr u1
        call        ConversionNum
        pop         word ptr u1
                       
    salida_for:    
        inc         di                                                                                          ; Pasa al siguiente caracter
        dec         cx
        cmp         cx, 0
        jne         for_puente

                
    ; Ajustar los numeros para las operaciones
        mov         cx,0                                                                                        ;limpiar cx para realizar ajuste
    ajustar:       
        mov         conver1,0                                                                                   ;variable para almacenar las decenas multiplicadas por 10
        mov         conver2,0                                                                                   ;variable para almacenar las centenas multiplicadas por 100
        cmp         cx,1                                                                                        ;comparar si cx es 1 (si ya se ingreso num1)
        je          ajustarC1                                                                                   ;si es 1 saltar a ajustarC1

    ajustarC:      
        cmp         c,0                                                                                         ;comparar si c es 0
        jz          ajustarD                                                                                    ;si es 0 saltar a ajustar d
        AjustarNumM c, 100, conver1                                                                             ;Multiplica c * 100

            
    ajustarD:      
        cmp         d,0                                                                                         ;comparar si d es 0
        jz          armar1                                                                                      ;si es 0 saltar a armar u
        AjustarNumM d,10,conver2                                                                                ;Multiplica d * 10

    armar1:                                                                                                     ;etiqueta para armar num1 tomado de linea de comandos
        push        word ptr num1
        push        word ptr conver1
        push        word ptr conver2
        push        word ptr u
        call        armarP
        pop         word ptr num1


    ;validar num1
        cmp         num1,000d                                                                                   ;comparar si num1 es menor a 000
        jl          errorNums                                                                                   ;si es menor a 0 saltar a errorNum
        cmp         num1,999d                                                                                   ;comparar si num1 es mayor a 999
        jg          errorNums                                                                                   ;si es mayor a 999 saltar a errorNum
        mov         cx,1                                                                                        ;poner cx en 1 para indicar que ya se ingreso num1
        jmp         ajustar                                                                                     ;si es valido continuar con num2
        
    ajustarC1:     
        mov         conver1,0                                                                                   ;variable para almacenar las decenas multiplicadas por 10
        mov         conver2,0                                                                                   ;variable para almacenar las centenas multiplicadas por 100
        cmp         c1,0                                                                                        ;comparar si c es 0
        jz          ajustarD1                                                                                   ;si es 0 saltar a ajustar d
        AjustarNumM c1,100,conver1                                                                              ;Multiplica c1 * 100

    ajustarD1:     
        cmp         d1,0                                                                                        ;comparar si d es 0
        jz          armar2                                                                                      ;si es 0 saltar a armar u
        AjustarNumM d1,10,conver2                                                                               ;Multiplica d1 * 10

    armar2:                                                                                                     ;etiqueta para armar num1 tomado de linea de comandos
        push        word ptr num2
        push        word ptr conver1
        push        word ptr conver2
        push        word ptr u1
        call        armarP
        pop         word ptr num2

    ;validar num2
        cmp         num2,000d                                                                                   ;comparar si num2 es menor a 0
        jl          errorNums                                                                                   ;si es menor a 000 saltar a errorNum
        cmp         num2,999d                                                                                   ;comparar si num2 es mayor a 999
        jg          errorNums                                                                                   ;si es mayor a 999 saltar a errorNum
        jmp         short siga1                                                                                 ;si es valido continuar

    errorNums:     
        mov         dx, offset errorNum                                                                         ;mensaje de error numero
        pushA
        call        PrintString
        call        WaitKeyP                                                                                    ;esperar a que el usuario presione una tecla
        mov         num1,0                                                                                      ;reiniciar num1 en caso de error
        mov         num2,0                                                                                      ;reiniciar num2 en caso de error
        jmp         ayudas                                                                                      ;saltar a ayudas
    puenteAyudas2: 
        jmp         puenteAyudas

    siga1:                                                                                                      ;etiqueta para leer y comparar operando
    ;leer operando
        xor         bp,bp                                                                                       ;limpiar registro bp

    ;comparar operando
        cmp         operando,"+"                                                                                ;comparar si es +
        je          sumaOp                                                                                      ;si es + saltar a sumaOp
        cmp         operando,"-"                                                                                ;comparar si es -
        je          puenteRes                                                                                   ;si es - saltar a restaOp
        cmp         operando,"*"                                                                                ;comparar si es *
        je          puenteMult                                                                                  ;si es * saltar a puenteMult
        cmp         operando,"/"                                                                                ;comparar si es /
        je          puenteDiv                                                                                   ;si es / saltar a divOp
        jmp         short errorOper                                                                             ;si no es ninguno de los 4 saltar a inicio

    errorOper:     
        mov         dx, offset errorOp                                                                          ;mensaje de error operando
        pushA
        call        PrintString
        call        WaitKeyP                                                                                    ;esperar a que el usuario presione una tecla
        mov         operando,0                                                                                  ;reiniciar operando en caso de error
        jmp         short puenteAyudas                                                                          ;saltar a ayudas

    sumaOp:        
        push        word ptr suma
        push        word ptr num1
        push        word ptr num2
        call        SumaP
        pop         word ptr suma
                   
        jmp         short sigaSuma

puenteRes:     
    jmp         restaOp                                                                                         ;saltar a restaOp
puenteMult:    
    jmp         puenteMult1                                                                                     ;saltar a multOp
puenteDiv:     
   jmp         puenteDiv1                                                                                       ;saltar a divOp
            
    sigaSuma:      
    ;imprimir resultado
        mov         dx, offset RSuma                                                                            ;mensaje de resultado suma
        pushA
        call        PrintString
        push        word ptr suma
        push        word ptr uMillar
        push        word ptr c
        push        word ptr d
        push        word ptr u
        call        ImprimirResultadoSR
                   
        jmp         puenteSalir1                                                                                ;saltar a salir

puenteAyudas:  
    jmp         puenteAyudas1                                                                                   ;saltar a ayudas

    restaOp:       
        push        word ptr resta
        push        word ptr num1
        push        word ptr num2
        call        RestaP
        pop         word ptr resta
                   

    ;imprimir resultado
        mov         dx, offset RResta                                                                           ;mensaje de resultado resta
        pushA
        call        PrintString
        mov         ax, resta                                                                                   ;poner en ax el valor de resta
        cmp         ax,0                                                                                        ;comparar si el resultado es negativo
        jge         positivo                                                                                    ;si es mayor o igual a 0 saltar a positivo
        xor         dx,dx                                                                                       ;limpiar dx para hacer la negacion
        mov         dl,'-'                                                                                      ;poner en dl el signo negativo
        push        dx                                                                                          ;pasar el signo negativo por pila
        call        PrintCharP                                                                                  ;llamar a PrintCharP para imprimir el signo negativo
        pop         dx
        mov         ax,resta
        neg         ax                                                                                          ;hacer positivo el valor de ax
        jmp         short positivo

    puenteMult1:   
        jmp         multOp                                                                                      ;saltar a multOp

    positivo:      
        push        ax
        push        word ptr uMillar
        push        word ptr c
        push        word ptr d
        push        word ptr u
        call        ImprimirResultadoSR                                                                         ; Imprime el restualdo de la suma
        jmp         short puenteSalir1                                                                          ;saltar a salir

puenteSalir1:  
    jmp         puenteSalir2                                                                                    ;saltar a salir
puenteDiv1:    
    jmp         divOp                                                                                           ;saltar a divOp
puenteAyudas1: 
    jmp         ayudas                                                                                          ;saltar a ayudas


    multOp:        
        MultM       u, d, c, u1, d1, c1, registro, auxiliar, cero, uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, diez, once

    ;imprimir resultado
        mov         dx, offset RMult                                                                            ;mensaje de resultado multiplicacion
        pushA
        call        PrintString
        mov         ax, mult                                                                                    ;poner en ax el valor de mult
        push        word ptr once                                                                               ;reservar espacio en la pila para cMillar
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        push        word ptr siete                                                                              ;reservar espacio en la pila para dMillar
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        push        word ptr tres                                                                               ;reservar espacio en la pila para uMillar
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        push        word ptr dos                                                                                ;reservar espacio en la pila para centenas
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        push        word ptr uno                                                                                ;reservar espacio en la pila para decenas
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        push        word ptr cero                                                                               ;reservar espacio en la pila para unidades
        call        PrintNum                                                                                    ;llamar a PrintNum para imprimir el resultado
        jmp         short puenteSalir2                                                                          ;saltar a salir

puenteSalir2:  
    jmp         puenteSalir                                                                                     ;saltar a salir

    divOp:         
    ;division obtener parte entera
        xor         ax,ax                                                                                       ;limpiar ax
        xor         bx,bx                                                                                       ;limpiar bx
        mov         ax,num1                                                                                     ;poner en ax el valor de num1
        xor         dx,dx                                                                                       ;extender el dividendo a 32 bits (DX:AX)
        mov         cx,num2                                                                                     ;poner en cx el valor de num2
        cmp         cx,0                                                                                        ;comparar si num2 es 0 para evitar division por 0
        je          error                                                                                       ;si es 0 saltar a error
        div         cx                                                                                          ;dividir ax entre cx, AX = cociente (parte entera), DX = residuo (parte decimal)
            
    ;almacenar la parte entera en el buffer
        mov         di, offset bufferDiv+4                                                                      ;puntero al final de la parte entera del buffer
    loopNum:       
        push        di                                                                                          ;guardar buffer en la pila
        push        ax                                                                                          ; guarda la parte entera
        push        dx                                                                                          ;guardar el residuo en la pila
        call        print_num
        pop         dx
        pop         ax
        pop         di
        cmp         ax,0                                                                                        ;comparar cociente con 0
        jne         loopNum                                                                                     ;si no, continuar

    ;calcular la parte fraccionaria (2 decimales)
        mov         ax,dx                                                                                       ;mover el residuo de la division a ax
        mov         cx,100                                                                                      ;multiplicar por 100 para obtener 2 decimales
        mul         cx                                                                                          ;ax * 100. resultado de 16*16 bits va a DX:AX
        mov         cx,num2                                                                                     ;poner en cx el valor de num2 (divisor)
        div         cx                                                                                          ;dividir DX:AX por cx
    ;resultado: AX = parte decimal, DX = residuo
            
    ;almacenar la parte fraccionaria en el buffer
        mov         di, offset bufferDiv+6                                                                      ;puntero al final de la parte decimal del buffer
        push        di                                                                                          ;se guarda el buffer de división
        push        ax                                                                                          ;se guardan los dos decimales del resultado
        call        print_dec                                                                                   ;imprimir decimales

    ;impresion resultado
        mov         dx, offset RDiv                                                                             ;mensaje de resultado division
        pushA
        call        PrintString
        mov         dx,offset bufferDiv
        pushA
        call        PrintString
                       
        jmp         short puenteSalir                                                                           ;saltar a salir

    error:         
        mov         dx, offset errorDiv                                                                         ;mensaje de error division por 0
        pushA
        call        PrintString
        call        WaitKeyP                                                                                    ;esperar a que el usuario presione una tecla

;final
puenteSalir:   
    jmp         short salga                                                                                     ;saltar a salida del programa


    ayudas:        
        mov         bh,0fh                                                                                      ;da color blanco a la pantalla
        xor         cx,cx                                                                                       ;pone en 0 ch y cl
        mov         dh,24                                                                                       ;fila inferior
        mov         dl,79                                                                                       ;columna inferior
        pushA
        call        ClearScreenP
        xor         dx,dx                                                                                       ;poner en 0 dh y dl para redireccionar cursor a 0,0
        call        GotoXYP
        mov         dx,offset ayuda                                                                             ;mensaje de ayuda
        pushA
        call        PrintString

    Salga:         
        mov         ax,4c00h                                                                                    ;codigo para terminar el programa
        int         21h

Codigo EndS
    End Inicio
