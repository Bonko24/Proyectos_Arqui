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