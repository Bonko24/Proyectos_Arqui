;Anthony Rodriguez 2021120181
;Calculadora basica que realiza suma, resta, multiplicacion y division de 2 numeros de 1 digito
;Si el usuario ingresa algo en linea de comandos se le mostrara un mensaje de ayuda
;Si el usuario no ingresa nada en linea de comandos se ejecutara la calculadora normalmente

;---------------------------------------------------------
;Para compilar usar:
;1) tener el archivo compilar.bat en la misma carpeta que los archivos .asm
;2) copiar esto en el DosBox: compilar tc7 proc
;3) td tc7 (debugear)  o  tc7 (ejecutar)
;NOTA: si agrega algo luego del nombre tc7 imprimira el mensaje de ayuda
;--------------------------------------------------------- 

;llamadas a procedimientos en proc.asm
include macros.asm
extrn InicializarDS:Far, ClearScreenP:Far, WhereXYP:Far, GotoXYP:Far, PrintCharColorP:Far, PrintCharP:Far, PrintNum:Far, PrintString:Far, ReadKey:Far,WaitKeyP:Far

Pila Segment
    db 64 Dup ('?')
Pila EndS

Datos Segment
    LongLC      EQU 80h
    ayuda       db 10,13,"Bienvenido y gracias por usar mi calculadora, por favor no ingrese nada en linea de comandos para ejecutar el programa",24h
    errorNum    db 10,13,"Error: Solo se permiten numeros de 1 digito (0-9)",  10,13,  "Presione cualquier tecla...",24h
    errorOp     db 10,13,"Error: Operando no valido",  10,13,  "Presione cualquier tecla...",24h
    errorDiv    db 10,13,"Error: No se puede dividir por 0",  10,13,  "Presione cualquier tecla...",24h

    ;introduccion de valores y menu
    mensajeRep  db 10,13,10,13,"Desea realizar algun otro calculo?",  10,13  ,"1)  SI",  10,13  ,"2)  NO",10,13,24h
    mensajeNum  db 10,13,"Digite un numero de 1 digito:       ",24h
    mensajeOper db 10,13,10,13,"Que operacion desea realizar?",  10,13  ,"1)  Suma (+)",  10,13  ,"2)  Resta (-)",  10,13  ,"3)  Multiplicacion (*)",  10,13  ,"4)  Division (/)",10,13,24h

    ;impresion de resultados
    RSuma       db 10,13,10,13,"El resultado de la suma es: ",24h
    RResta      db 10,13,10,13,"El resultado de la resta es: ",24h
    RMult       db 10,13,10,13,"El resultado de la multiplicacion es: ",24h
    RDiv        db 10,13,10,13,"El resultado de la division es: ",24h
    RRes        db 10,13,10,13,"El residuo de la division es: ",24h

    ;numeros y variables
    num1        dw ?
    num2        dw ?
    operando    db ?                            ;variable para almacenar el operando ingresado
    var         db ?                            ;variable para almacenar la respuesta de si desea repetir
    d           db ?                            ;variable para almacenar el digito de las decenas
    u           db ?                            ;variable para almacenar el digito de las unidades
    conver1     dw ?                            ;variable para almacenar las decenas multiplicadas por 10

    ;resultados
    suma        dw ?
    resta       dw ?
    mult        dw ?
    cociente    db ?
    residuo     db ?

    linecommand db 0FFh Dup (?)                 ;variable para almacenar la linea de comandos
Datos EndS

Codigo Segment
    Assume CS:Codigo, SS:Pila, DS:Datos

    GetCommanderLine Proc Near                  ;obtiene lo ingresado en linea de comandos y lo pone en var linecommand
        LongLC  EQU  80h
        mov bp,sp
        mov ax,es
        mov ds,ax
        mov di,2[bp]
        mov ax,4[bp]
        mov es,ax
        xor cx,cx
        mov cl,Byte ptr DS:[LongLC]
        dec cl
        mov si,2[LongLC]
        cld
        rep movsb
        ret 2*2
    GetCommanderLine EndP

Inicio:
    ;inicializacion Datos Segment
    mov ax,Datos
    push ax
    call InicializarDS
    pop ax

    ;limpiar pantalla y redireccionar cursor
    mov bh,0fh                                  ;da color blanco a la pantalla
    xor cx,cx                                   ;pone en 0 ch y cl
    mov dh,24                                   ;fila inferior
    mov dl,79                                   ;columna inferior
    pushA                     
    call ClearScreenP                           ;limpiar pantalla
    xor dx,dx                                   ;poner en 0 dh y dl para redireccionar cursor a 0,0
    call GotoXYP                                ;redireccionar cursor a 0,0

    ;leer linea de comandos
    push ds
    mov ax,seg linecommand                      ;poner en ax el segmento de la variable linecommand
    push ax
    lea ax,linecommand                           ;poner en ax el offset de la variable linecommand
    push ax
    call GetCommanderLine
    
    mov bh, byte ptr DS:[LongLC]                ;poner en bh el numero de caracteres que tiene la linea de comandos (len)
    cmp bh,0                                    ;compara para ver si es vacio
    jne puente
    jmp short calculadora                       ;en caso de no ser igual salta a calculadora

puente:                                         ;puente para saltar ayuda en caso de ingresar algo en linea de comandos
    pop ds
    jmp ayudas

    calculadora:
        ;ajustar es / ds
        mov ax,ds                               ;guardar ds en ax
        mov es,ax                               ;poner es = ds
        pop ds                                  ;recuperar ds

        pedirNum1:     
        mov d,0                                 ;inicializar d en 0 para evitar errores si solo se ingresa un digito
        mov conver1,0                           ;inicializar conver1 en 0 para evitar errores si solo se ingresa un digito
        mov dx,offset mensajeNum                ;mensaje para pedir num1
        pushA
        call PrintString
        push word ptr u                         ;reservar espacio en la pila para u
        pushA
        call ReadKey
        pop word ptr u                          ;con este pop se pone el valor almacenado en la pila ingresado con ReadKey en la var u
        xor bp,bp                               ;limpiar registro bp
        sub u,30h                               ;convertir de ASCII a valor numerico

            armar1:                             ;etiqueta para armar num1
                xor ax,ax                       ;limpiar ax
                mov ax,conver1                  ;poner en ax el valor de conver1
                add num1,ax                     ;sumar d a num1
                xor ax,ax                       ;limpiar ax
                mov al,u                        ;poner en al el valor de u
                add num1,ax                     ;sumar u a num1

                ;validar num1
                cmp num1,0                      ;comparar si num1 es menor a 0
                jl errorNum1                    ;si es menor a 0 saltar a errorNum1
                cmp num1,9                      ;comparar si num1 es mayor a 9
                jg errorNum1                    ;si es mayor a 9 saltar a errorNum1
                jmp short pedirNum2             ;si es valido continuar

                errorNum1:
                    mov dx, offset errorNum     ;mensaje de error num1
                    pushA
                    call PrintString
                    call WaitKeyP               ;esperar a que el usuario presione una tecla
                    mov num1,0                  ;reiniciar num1 en caso de error
                    jmp short pedirNum1         ;saltar a pedirNum1 nuevamente

        pedirNum2:
        mov dx,offset mensajeNum                ;mensaje para pedir num2
        pushA
        call PrintString
        push word ptr u                         ;reservar espacio en la pila para u
        pushA
        call ReadKey
        pop word ptr u                          ;con este pop se pone el valor almacenado en la pila ingresado con ReadKey en la var u
        xor bp,bp                               ;limpiar registro bp
        sub u,30h                               ;convertir de ASCII a valor numerico
        
            armar2:                             ;etiqueta para armar num2
                xor ax,ax                       ;limpiar ax
                mov ax,conver1                  ;poner en ax el valor de conver1
                add num2,ax                     ;sumar d a num2
                xor ax,ax                       ;limpiar ax
                mov al,u                        ;poner en al el valor de u
                add num2,ax                     ;sumar u a num2

                ;validar num2
                cmp num2,0                      ;comparar si num2 es menor a 0
                jl errorNum2                    ;si es menor a 0 saltar a errorNum2
                cmp num2,9                      ;comparar si num2 es mayor a 9
                jg errorNum2                    ;si es mayor a 9 saltar a errorNum2
                jmp short siga1                 ;si es valido continuar

                errorNum2:
                    mov dx, offset errorNum     ;mensaje de error num2
                    pushA
                    call PrintString
                    call WaitKeyP               ;esperar a que el usuario presione una tecla
                    mov num2,0                  ;reiniciar num2 en caso de error
                    jmp short pedirNum2         ;saltar a pedirNum2 nuevamente

puente1:
    jmp Inicio
puente2:
    jmp calculadora

        siga1:
            ;pedir operando
            mov dx,offset mensajeOper           ;mensaje para pedir operando
            pushA
            call PrintString                                                    
            push word ptr operando              ;reservar espacio en la pila para operando
            pushA
            call ReadKey
            pop word ptr operando               ;con este pop se pone el valor almacenado en la pila ingresado con ReadKey en la var operando
            xor bp,bp                           ;limpiar registro bp

            ;comparar operando
            cmp operando,"1"                    ;comparar si es +
            je sumaOp                           ;si es + saltar a sumaOp
            cmp operando,"2"                    ;comparar si es -
            je restaOp                          ;si es - saltar a restaOp
            cmp operando,"3"                    ;comparar si es *
            je puenteMult                       ;si es * saltar a puenteMult
            cmp operando,"4"                    ;comparar si es /
            je puenteDiv                        ;si es / saltar a divOp
            jmp short errorOper                 ;si no es ninguno de los 4 saltar a inicio

            errorOper:
                mov dx, offset errorOp          ;mensaje de error operando
                pushA
                call PrintString
                call WaitKeyP                   ;esperar a que el usuario presione una tecla
                mov operando,0                  ;reiniciar operando en caso de error
                jmp short siga1                 ;saltar a pedir operando nuevamente

        sumaOp:
            xor ax,ax                           ;limpiar ax
            xor bx,bx                           ;limpiar bx
            mov ax, num1                        ;poner en ax el valor de num1
            add suma, ax                        ;sumar num1 a suma
            mov ax, num2                        ;poner en ax el valor de num2
            add suma, ax                        ;sumar num2 a suma
            
            ;imprimir resultado
            mov dx, offset RSuma                ;mensaje de resultado suma
            pushA
            call PrintString
            mov ax, suma                        ;poner en ax el valor de suma
            aam                                 ;ajustar ax para separar decenas y unidades
            mov u,al                            ;guardar unidades en u
            mov al,ah                           ;pasar decenas a al
            mov d,al                            ;guardar decenas en d
            push word ptr d                     ;reservar espacio en la pila para d
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            push word ptr u                     ;reservar espacio en la pila para u
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            jmp short puente3                   ;saltar a repetir

puenteMult:
    jmp multOp                                  ;saltar a multOp
puenteDiv:
    jmp divOp                                   ;saltar a divOp

        restaOp:
            xor ax,ax                           ;limpiar ax
            mov ax, num1                        ;poner en ax el valor de num1       
            sub ax, num2                        ;restar num2 a ax
            mov resta, ax                       ;almacenar el resultado en resta

            ;imprimir resultado
            mov dx, offset RResta               ;mensaje de resultado resta
            pushA
            call PrintString
            mov ax, resta                       ;poner en ax el valor de resta
            cmp ax,0                            ;comparar si el resultado es negativo
            jge positivo                        ;si es mayor o igual a 0 saltar a positivo
            xor dx,dx                           ;limpiar dx para hacer la negacion
            mov dl,'-'                          ;poner en dl el signo negativo
            push dx                             ;pasar el signo negativo por pila
            call PrintCharP                     ;llamar a PrintCharP para imprimir el signo negativo
            pop dx
            neg ax                              ;hacer positivo el valor de ax

            positivo:
                push ax                         ;pasar el valor de ax por pila para imprimirlo
                call PrintNum                   ;llamar a PrintNum para imprimir el resultado
                pop ax                          ;recuperar ax
                jmp short puente3               ;saltar a repetir

        multOp:
            xor ax,ax                           ;limpiar ax
            mov ax, num1                        ;poner en ax el valor de num1
            mov bx, num2                        ;poner en bx el valor de num2
            mul bx                              ;multiplicar ax por bx
            mov mult, ax                        ;almacenar el resultado en mult

            ;imprimir resultado
            mov dx, offset RMult                ;mensaje de resultado multiplicacion
            pushA
            call PrintString
            mov ax, mult                        ;poner en ax el valor de mult
            aam                                 ;ajustar ax para separar decenas y unidades
            mov u,al                            ;guardar unidades en u
            mov al,ah                           ;pasar decenas a al
            mov d,al                            ;guardar decenas en d
            push word ptr d                     ;reservar espacio en la pila para d
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            push word ptr u                     ;reservar espacio en la pila para u
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            jmp short puente3                   ;saltar a repetir

puente3:
    jmp repetir
puente4:
    jmp puente1

        divOp:
            xor ax,ax                           ;limpiar ax
            mov ax,num1                         ;poner en ax el valor de num1
            mov bx,num2                         ;poner en bx el valor de num2
            cmp bx,0                            ;comparar si num2 es 0 para evitar division por 0
            je error                            ;si es 0 saltar a error
            div bl                              ;dividir ax entre bl, cociente en al, residuo en ah
            mov cociente, al                    ;almacenar el cociente en cociente
            mov residuo, ah                     ;almacenar el residuo en residuo

            ;imprimir resultado
            mov dx, offset RDiv                 ;mensaje de resultado division
            pushA
            call PrintString
            mov al,cociente                     ;poner en al el valor de cociente
            aam                                 ;ajustar ax para separar decenas y unidades
            mov u,al                            ;guardar unidades en u
            mov al,ah                           ;pasar decenas a al
            mov d,al                            ;guardar decenas en d
            push word ptr d                     ;reservar espacio en la pila para d
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            push word ptr u                     ;reservar espacio en la pila para u
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            mov dx, offset RRes                 ;mensaje de resultado residuo
            pushA
            call PrintString
            mov al,residuo                      ;poner en al el valor de residuo
            aam                                 ;ajustar ax para separar decenas y unidades
            mov u,al                            ;guardar unidades en u
            mov al,ah                           ;pasar decenas a al
            mov d,al                            ;guardar decenas en d
            push word ptr d                     ;reservar espacio en la pila para d
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            push word ptr u                     ;reservar espacio en la pila para u
            call PrintNum                       ;llamar a PrintNum para imprimir el resultado
            jmp short puente3                   ;saltar a repetir

                error:
                    mov dx, offset errorDiv     ;mensaje de error division por 0
                    pushA
                    call PrintString
                    call WaitKeyP               ;esperar a que el usuario presione una tecla

            reiniciarVar:
                mov num1,0                      ;reiniciar num1 en caso de que el usuario desee hacer otra operacion
                mov num2,0                      ;reiniciar num2 en caso de que el usuario desee hacer otra operacion
                mov suma,0                      ;reiniciar suma en caso de que el usuario desee hacer otra operacion
                mov resta,0                     ;reiniciar resta en caso de que el usuario desee hacer otra operacion
                mov mult,0                      ;reiniciar mult en caso de que el usuario desee hacer otra operacion
                mov cociente,0                  ;reiniciar cociente en caso de que el usuario desee hacer otra operacion
                mov residuo,0                   ;reiniciar residuo en caso de que el usuario desee hacer otra operacion
                jmp puente4                     ;saltar a pedir num1 nuevamente

        repetir:
        ;si el usuario desea realizar otra operacion
        mov dx,offset mensajeRep                ;mensaje para pedir si desea repetir
        pushA
        call PrintString
        push word ptr var                       ;reservar espacio en la pila para var
        pushA
        call ReadKey
        pop word ptr var                        ;con este pop se pone el valor almacenado en la pila ingresado con ReadKey en la var var
        xor bp,bp                               ;limpiar registro bp

        ;comparar respuesta
        cmp var,31h                             ;comparar si es 1 (si)
        je reiniciarVar                         ;si es 1 saltar a reiniciarVar

        ;final
        jmp short salga                         ;saltar a salida del programa


    ayudas:
        mov bh,0fh                              ;da color blanco a la pantalla
        xor cx,cx                               ;pone en 0 ch y cl
        mov dh,24                               ;fila inferior
        mov dl,79                               ;columna inferior
        pushA
        call ClearScreenP
        xor dx,dx                               ;poner en 0 dh y dl para redireccionar cursor a 0,0
        call GotoXYP
        mov dx,offset ayuda                     ;mensaje de ayuda
        pushA
        call PrintString

Salga:
    mov ax,4c00h                                ;codigo para terminar el programa
    int 21h

Codigo EndS
    End Inicio
