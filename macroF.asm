;-------MACROS------
; Escibe un pizel de un color en la pantalla
EscribirPixel Macro fila,columna,color
           mov             ah,0ch
           mov             al,color                 ; color
           xor             bh,bh                    ; página cero (la que se está viendo)
           mov             cx,columna               ; columna
           mov             dx,fila                  ; fila
           int             10h
EndM

; Dibuja una línea horizontal de la longitud solucitada por el usuario anteriormente 
LineaHorizontal Macro longitud, color_int, columna, fila
local lineaH
                           mov cx, longitud
                           mov ax, color_int   ; color e interrupción
                           xor bh, bh          ; página cero
                           mov dx, columna
                           mov bp, fila        ; BP usado como contador temporal de fila
    lineaH:                                                               
                           push cx
                           mov cx, dx          ; columna
                           mov dx, bp          ; fila actual
                           int 10h
                           inc bp              ; siguiente fila
                           pop cx
                           loop          lineaH
EndM

; Dibuja una línea horizontal de la longitud solucitada
LineaVerticalM MACRO longitud, color_int, columna, fila
    LOCAL lineaV
    mov cx, longitud
    mov ax, color_int   ; color e interrupción
    xor bh, bh          ; página cero
    mov dx, columna
    mov bp, fila        ; BP usado como contador temporal de fila
    
lineaV:
    push cx
    mov cx, dx          ; columna
    mov dx, bp          ; fila actual
    int 10h
    inc bp              ; siguiente fila
    pop cx
    loop lineaV
ENDM

; Dibuja una línea diagonal ascendente para el rombo de la longitud solicitada
RomboDiagonalAscendenteM MACRO longitud, color_int, columna, fila
    LOCAL romboDA
    mov cx, longitud
    mov ax, color_int   ; color y número de interrupción
    xor bh, bh          ; página cero
    mov dx, columna
    mov bp, fila        ; BP usado como contador temporal de fila
    
romboDA:
    push cx
    mov cx, dx          ; columna actual
    mov dx, bp          ; fila actual
    int 10h
    dec dx              ; columna-1 
    inc bp              ; fila+1
    pop cx
    loop romboDA
ENDM

; Dibuja una línea diagonal descendente para el rombo de la longitud solicitada.
RomboDiagonalDescendenteM MACRO longitud, color_int, columna, fila
    LOCAL romboDD
    mov cx, longitud
    mov ax, color_int
    xor bh, bh          ; página cero
    mov dx, columna
    mov bp, fila        ; BP usado como contador temporal de fila
    
romboDD:
    push cx
    mov cx, dx          ; columna actual
    mov dx, bp          ; fila actual
    int 10h
    inc dx              ; columna+1 (
    inc bp              ; fila+1 
    pop cx
    loop romboDD
ENDM

; Dibuja una línea diagonal ascendente para el triangulo de la longitud solicitada
TrianguloDiagonalAscendenteM MACRO longitud, color_int, columna, fila
    LOCAL trianguloDA
    mov cx, longitud
    mov ax, color_int
    xor bh, bh          ; página cero
    mov dx, columna
    mov bp, fila        ; BP usado como contador temporal de fila
    
trianguloDA:
    push cx
    mov cx, dx          ; columna actual
    mov dx, bp          ; fila actual
    int 10h
    dec dx              ; columna-1 (izquierda)
    add bp, 2           ; fila+2 (abajo más rápido)
    pop cx
    loop trianguloDA
ENDM

; Dibuja una línea diagonal descendente para el triangulo de la longitud solicitada
TrianguloDiagonalDescendenteM MACRO longitud, color_int, columna, fila
    LOCAL trianguloDD
    mov cx, longitud
    mov ax, color_int
    xor bh, bh          ; página cero
    mov dx, columna
    mov bp, fila        ; BP usado como contador temporal de fila
    
trianguloDD:
    push cx
    mov cx, dx          ; columna actual
    mov dx, bp          ; fila actual
    int 10h
    inc dx              ; columna+1 (derecha)
    add bp, 2           ; fila+2 (abajo más rápido)
    pop cx
    loop trianguloDD
ENDM

; Dibujar una línea horizontal entre dos puntos
LineaHorizontal2M MACRO color_int, columna_inicio, fila, columna_final
    LOCAL lineaH2
    mov ax, color_int
    xor bh, bh          ; página cero
    mov cx, columna_inicio
    mov dx, fila
    mov si, columna_final
    
lineaH2:
    int 10h
    inc cx              ; siguiente columna
    cmp cx, si          ; Veririfcar si se llegó al final
    jle lineaH2         ; si no, continuar
ENDM

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

TerminaPrograma Macro codigosalida                                  ;Termina el programa
    mov ah,4ch
    mov al,codigosalida
    int 21h
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