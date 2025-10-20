; MACROS DEL PROYECTO CRUD
; Guarda datos en el buffer
input_buffersM Macro mensaje, buffer
                   lea  dx, mensaje
                   push dx
                   call print_string
                   lea  dx, buffer
                   push dx
                   call input_string
ENDM


; Limpia la pantalla 
ClearScreenM Macro
    pusha
    mov    ah, 07h
    xor    al, al
    int    10h
    popa
EndM

; Mueve el cursor.
GotoXYM Macro
    pusha
    mov    ah, 02h
    xor    bh, bh
    int    10h
    popa
EndM

; Espera a que se presione una tecla.
WaitKeyM Macro
    pusha
    mov    ah, 00h
    int    16h
    popa
EndM



; Imprime cadena terminada en '$'
print_stringM Macro mensaje
    pusha
    mov    dx, mensaje
    mov    ah, 09h
    int    21h
    popa
EndM

;  Lee entrada de teclado
input_stringM Macro buffer
    pusha
    mov    dx, buffer
    mov    ah, 0Ah
    int    21h
    popa
EndM



; Crea archivo
crear_archivoM Macro nombre
    pusha
    mov    dx, nombre
    mov    cx, 0
    mov    ah, 3Ch
    int    21h
    popa
EndM


; abre archivo dependiendo de su modo
abrir_archivoM Macro modo, nombre
    pusha
    mov    ax, modo
    mov    dx, nombre
    int    21h
    popa
EndM

; Cierra archivo
cerrar_archivoM Macro handle
    pusha
    mov    bx, handle_val
    mov    ah, 3Eh
    int    21h
    popa
EndM

; Limpia 4096 bytes del buffer.
vaciar_bufferM Macro buffer
    pusha
    mov    di, buffer
    mov    cx, 4096
    xor    al, al
    push   ds
    pop    es
    rep    stosb
    popa
EndM

; Escribe un solo carácter
write_charM Macro handle_val, char_val
    pusha
    mov    bx, handle_val
    mov    dl, char_val
    mov    cx, 1
    mov    ah, 40h
    int    21h
    popa
EndM

;---Macros para realizar pushAll, popAll---
ListPush Macro lista
             IRP  i,<lista>
             Push i
ENDM
EndM

ListPop Macro lista
            IRP i,<lista>
            Pop i
ENDM
EndM

PushA Macro
    ListPush <Ax,Bx,Cx,Dx,Si,Bp,Sp>
EndM

PopA Macro
    ListPop <Sp,Bp,Si,Dx,Cx,Bx,Ax>
EndM
