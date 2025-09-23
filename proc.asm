;Libreria de procedimientos
Procedimientos Segment
;aca proc debe ser far

public InicializarDS, ClearScreenP, WhereXYP, GotoXYP, PrintCharColorP, PrintCharP, PrintNum, PrintString, ReadKey, WaitKeyP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal 
    ;debe mandar en el ax el segmento de datos
    ;ej
    ;{ mov ax,Datos
    ;  push ax
    ;  call InicializarDS
    ;---------------------------------------------------------
    InicializarDS Proc Far
        xor ax,ax
        mov bp,sp
        mov ax,4[bp]
        mov ds,ax
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
        mov ah,07h
        xor al,al
        int 10h
        RetF 7*2
    ClearScreenP EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;realizar un push word ptr "var" variable donde se quiere 
    ;poner el numero de fila y otro para el numero de columna
    ;despues del call un pop word ptr "var" para la fila y 
    ;otro para la comlumna
    ;---------------------------------------------------------
    WhereXYP Proc Far
        mov ah,03h
        xor bh,bh
        mov bp,sp
        int 10h
        mov 6[bp],dh        ;poner en "fila" el valor de la fila retornado
        mov 4[bp],dl        ;poner en "columna" el valor de la columna retornado
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
        mov ah,02h
        xor bh,bh
        int 10h
        RetF
    GotoXYP EndP

    ;--------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;al= caracter a imprimir, bl= color del caracter, 
    ;cx= cantidad de caracteres a imprimir (pasar por pila)
    PrintCharColorP Proc Far
        mov ah,09h
        xor bh,bh
        mov cx,4[bp]
        int 10h
        RetF
    PrintCharColorP EndP

    ;--------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;poner en el dl el caracter a imprimir
    PrintCharP Proc Far
        mov bp,sp
        mov ah,02h
        mov dl,4[bp]
        int 21h
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
        mov ah,09h
        int 21h
        RetF 7*2
    PrintString EndP

    ;---------------------------------------------------------
    ;antes de llamar al proc en el programa principal se debe
    ;enviar por pila en dl el num a imprimir
    ;num debe venir en forma decimal, es decir con un signo ASCII
    ;ejem: 5 es un trebol, ya que el 5 de consola entra como 35h
    ;y eso nos da un 5 en decimal restandole 30h
    PrintNum Proc Far
        mov bp,sp
        mov ah,02h
        mov dl,4[bp]
        add dl,30h
        int 21h
        RetF
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
        mov bp,sp
        mov ah,01h
        int 21h
        mov 12h[bp],al                              
        RetF 7*2                                    
    ReadKey EndP

    WaitKeyP Proc Far    
    mov ah,01h
    int 21h
    RetF
    WaitKeyP EndP


Procedimientos EndS
    End