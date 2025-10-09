;Víctor Esteban Azofeifa Portuguez 2023113603 y Anthony Rodriguez Alpizar 2021120181
;Libreria de procedimientos para Programa basico de un CRUD de tarjetas de empleados


public ClearScreenP, GotoXYP, WaitKeyP, print_string, input_string, write_comma, write_backSlash

Procedimientos Segment

    ;antes de llamar al proc en el programa principal 
    ;debe mandar en el bh (atributo),ch (fila inferior), 
    ;cl (columna inferior),dh (fila superior),dl (columna superior)
    ;y posterior un pushA
    ClearScreenP Proc Far
        mov ah,07h
        xor al,al
        int 10h
        RetF 7*2
    ClearScreenP EndP


    ;Mueve el cursor a la posicion (dh,fila) , (dl,columna)
    ;antes de llamar al proc en el programa principal se debe
    ;dh (fila) , dl (columna) a poner el cursor
    GotoXYP Proc Far
        mov ah,02h
        xor bh,bh
        int 10h
        Ret
    GotoXYP EndP

    WaitKeyP Proc Far    
        mov ah,01h
        int 21h
        RetF
    WaitKeyP EndP

    ;imprime una cadena de caracteres
    print_string PROC Far
        mov bp,sp
        mov dx,[bp + 4]
        mov ah, 09h
        int 21h
        ret 2
    print_string ENDP

    ;recibe una cadena de caracteres
    input_string PROC Far
        mov bp,sp
        mov dx,[bp + 4]
        mov ah, 0Ah
        int 21h
        ret 2
    input_string ENDP

    ;escribe una coma en el archivo
    ;dx = bp + 4
    ;bx = handle = bp + 6
    write_comma PROC Far
        mov bp,sp
        mov dx, [bp + 4]
        mov bx, [bp + 6]
        mov cx,1
        mov ah,40h
        int 21h
        ret 4
    write_comma ENDP

    ;escribe una barra invertida en el archivo
    ;dx = bp + 4
    ;bx = handle = bp + 6
    write_backSlash PROC Far
        mov bp, sp
        mov dx, [bp + 4]
        mov bx, [bp + 6]
        mov cx, 1
        mov ah, 40h
        int 21h
        ret 4
    write_backSlash ENDP
    

Procedimientos ENDS
End