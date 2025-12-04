;Libreria de procedimientos
Procedimientos Segment
                                  Assume cs:Procedimientos
    ;aca proc debe ser far
                                  public InicializarDS, ClearScreenP, WhereXYP, GotoXYP, PrintCharColorP, PrintCharP, PrintNum, PrintString, ReadKey, WaitKeyP, input_string, EscribirPixelP, LineaHorizontalP, LineaVerticalP, RomboDiagonalAscendenteP, RomboDiagonalDescendenteP, TrianguloDiagonalAscendenteP, TrianguloDiagonalDescendenteP, LineaHorizontal2P
    
    ; Procedimientos del proyecto
    ; Procedimiento de la interrupción 10h,c para escrbir un pixel en la pantalla
    ; Ejemplo de uso
    ;mov           ax, 0c03h -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          EscribirPixelP
EscribirPixelP Proc Far
                                  mov    bp,sp
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  xor    bp,bp
                                  retf   6
EscribirPixelP EndP

    ; Dibujar una línea horizontal de la longitud solicitada por el usuario.
    ; Ejmplo de uso:
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          LineaHorizontalP
LineaHorizontalP Proc Far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    lineaH:                       
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  add    6[bp],1
                                  pop    cx
                                  loop   lineaH

                                  xor    bp,bp
                                  retf   8
LineaHorizontalP EndP

    ; Dibujar una línea horizontal de la longitud solicitada por el usuario.
    ;Ejemplo de uso:
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          LineaVerticalP
LineaVerticalP Proc Far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    lineaV:                       
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  add    4[bp],1
                                  pop    cx
                                  loop   lineaV

                                  xor    bp,bp
                                  retf   8

LineaVerticalP EndP

    ; Dibujar una línea diagonal ascendente para el Rombo
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          RomboDiagonalAscendenteP
RomboDiagonalAscendenteP proc far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    romboDA:                      
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  sub    6[bp],1                                                                                                                                                                                                                                                                                                                       ;avanzar un espacio a la derecha
                                  add    4[bp],1
                                  pop    cx
                                  loop   romboDA

                                  xor    bp,bp
                                  retf   8
RomboDiagonalAscendenteP EndP

    ; Linea diagonal descendente para el rombo
    ; Ejemplo de uso:
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          RomboDiagonalDescendenteP
RomboDiagonalDescendenteP proc far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    romboDD:                      
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  add    6[bp],1                                                                                                                                                                                                                                                                                                                       ;avanzar un espacio a la derecha
                                  add    4[bp],1
                                  pop    cx
                                  loop   romboDD

                                  xor    bp,bp
                                  retf   8
RomboDiagonalDescendenteP EndP

    ; Dibuja una línea diagonal ascendente para el triángulo
    ; Ejemplo de uso:
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          TrianguloDiagonalAscendenteP
TrianguloDiagonalAscendenteP proc far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    trianguloDA:                  
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  sub    6[bp],1                                                                                                                                                                                                                                                                                                                       ;Se mueve una columna a la izquierda
                                  add    4[bp],2                                                                                                                                                                                                                                                                                                                       ;Se mueve dos filas abajo
                                  pop    cx
                                  loop   trianguloDA

                                  xor    bp,bp
                                  retf   8
TrianguloDiagonalAscendenteP EndP

    ; Dibuja una línea diagonal descendente para el triángulo
    ; Ejemplo de uso:
    ;push          cx            -> longitud de la línea
    ;mov           ax, 0c05h     -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;call          TrianguloDiagonalDescendenteP
TrianguloDiagonalDescendenteP proc far
                                  mov    bp,sp
                                  mov    cx, 10[bp]
    trianguloDD:                  
                                  push   cx
                                  mov    ax, 8[bp]                                                                                                                                                                                                                                                                                                                     ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,6[bp]                                                                                                                                                                                                                                                                                                                      ; columna
                                  mov    dx,4[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  add    6[bp],1                                                                                                                                                                                                                                                                                                                       ;Se mueve una columna a la derecha
                                  add    4[bp],2                                                                                                                                                                                                                                                                                                                       ;Se mueve dos filas abajo
                                  pop    cx
                                  loop   trianguloDD

                                  xor    bp,bp
                                  retf   8
TrianguloDiagonalDescendenteP EndP

    ; Dibujar una línea horizontal entre dos puntos
    ; Ejmplo deuso:
    ;mov           ax, 0c03h                        -> ah:número de interrupción 10h y al: color
    ;push          ax
    ;push          columna
    ;push          fila
    ;push          columna_final
    ;call          LineaHorizontal2P
LineaHorizontal2P Proc Far
                                  mov    bp,sp
    lineaH2:                      
                                  mov    ax, 10[bp]                                                                                                                                                                                                                                                                                                                    ; Color e interrupcion
                                  xor    bh,bh                                                                                                                                                                                                                                                                                                                         ; página cero (la que se está viendo)
                                  mov    cx,8[bp]                                                                                                                                                                                                                                                                                                                      ; columna actual
                                  mov    dx,6[bp]                                                                                                                                                                                                                                                                                                                      ; fila
                                  int    10h
                                  add    8[bp],1
                                  mov    ax, 4[bp]                                                                                                                                                                                                                                                                                                                     ; punto final
                                  cmp    8[bp],ax                                                                                                                                                                                                                                                                                                                      ; Verifica si ya se llegó al punto final
                                  jle    lineaH2

                                  xor    bp,bp
                                  retf   8
LineaHorizontal2P EndP

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
                                  mov    6[bp],dh                                                                                                                                                                                                                                                                                                                      ;poner en "fila" el valor de la fila retornado
                                  mov    4[bp],dl                                                                                                                                                                                                                                                                                                                      ;poner en "columna" el valor de la columna retornado
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

    ;Espera a que se presione una tecla con echo
WaitKeyP Proc Far
                                  mov    ah,01h
                                  int    21h
                                  RetF
WaitKeyP EndP

    ;recibe una cadena de caracteres
input_string PROC Far
                                  mov    bp,sp
                                  mov    dx,[bp + 4]
                                  mov    ah, 0Ah
                                  int    21h
                                  ret    2
input_string ENDP


Procedimientos EndS
    End