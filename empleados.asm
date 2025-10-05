;Anthony Rodriguez 2021120181
;Libreria de procedimientos
public InicializarDS, ClearScreenP, PrintString, leerLinea ,copiarInputDestino ,copiarCedulaBuscar

Pila Segment
    db 64 Dup ('?')
Pila EndS

Datos Segment
    ; Mensajes comunes (compartidos)
    okMsg       DB 13,10,'Operacion completada.$'
    msgNoEncontrado DB 13,10,'Registro no encontrado.$'

    ; Buffers globales (accesibles desde cualquier PROC)
    inputBuf    DB 50 DUP(0)
    cedulaBuf   DB 20 DUP(0)
    tempCedBuf  DB 20 DUP(0)
    buffer      DB 256 DUP(0)
    writeBuf    DB 256 DUP(0)

    ; Campos del registro actual
    newEmpresa  DB 31 DUP(0)
    newNombre   DB 31 DUP(0)
    newCedula   DB 21 DUP(0)
    newEmail    DB 41 DUP(0)
    newPuesto   DB 31 DUP(0)
    newTelefono DB 16 DUP(0)
    newTiempo   DB 6 DUP(0)

    filename    DB 'empleados.txt', 0
    tempFile    DB 'temp.txt', 0
    renameFile  DB 'temp.txt',0,'empleados.txt',0
Datos EndS

Codigo Segment
    Assume CS:Codigo, SS:Pila, DS:Datos

    ;antes de llamar al proc en el programa principal 
    ;debe mandar en el ax el segmento de datos
    InicializarDS Proc Far
        xor ax,ax
        mov bp,sp
        mov ax,4[bp]
        mov ds,ax
        RetF 
    InicializarDS EndP

    ;antes de llamar al proc en el programa principal 
    ;debe mandar en el bh (atributo),ch (fila inferior), 
    ;cl (columna inferior),dh (fila superior),dl (columna superior)
    ;y posterior un pushA
    ClearScreenP Proc Far
        mov ah,07h
        xor al,al
        int 10h
        RetF 7*2
    ClearScreenP 
    
    ;antes de llamar al proc en el programa principal 
    ;debe mandar en el dx la var a imprimir con $ al final
    ;y posterior un pushA
    PrintString Proc Far
        mov ah,09h
        int 21h
        RetF 7*2
    PrintString EndP

    ;parámetro: [BP+6] = offset del buffer de destino
    ;lee una línea del teclado y la almacena terminada en '$' y 0
    leerLinea PROC
        PUSH BP
        MOV BP, SP
        PUSH AX
        PUSH CX
        PUSH DI

        MOV DI, [BP+6]      ;destino
        XOR CX, CX

    loopLeer:
        MOV AH, 01h
        INT 21h
        CMP AL, 13          ;Enter
        JE listo
        CMP CX, 49
        JAE leerLinea
        STOSB
        INC CX
        JMP leerLinea

    listo:
        MOV AL, '$'
        STOSB
        MOV AL, 0
        STOSB               ;terminación en 0 para comparaciones

        POP DI
        POP CX
        POP AX
        POP BP
        RET 2               ;limpia 2 bytes (1 palabra = offset)
    leerLinea ENDP

    ;parámetro: [BP+6] = offset del campo destino
    ;copia inputBuf (hasta '$') al campo
    copiarInputDestino PROC
        PUSH BP
        MOV BP, SP
        PUSH SI
        PUSH DI
        PUSH AX

        MOV SI, OFFSET inputBuf
        MOV DI, [BP+6]

    loopCopiar:
        LODSB
        CMP AL, '$'
        JE final
        STOSB
        JMP loopCopiar
    final:
        MOV AL, 0
        STOSB

        POP AX
        POP DI
        POP SI
        POP BP
        RET 2
    copiarInputDestino ENDP

    ;copia inputBuf a cedulaBuf (sin '$')
    copiarCedulaBuscar PROC
        PUSH SI
        PUSH DI
        PUSH AX

        MOV SI, OFFSET inputBuf
        MOV DI, OFFSET cedulaBuf

    loopCedula:
        LODSB
        CMP AL, '$'
        JE final
        STOSB
        JMP loopCedula

    final:
        MOV AL, 0
        STOSB

        POP AX
        POP DI
        POP SI
        RET
    copiarCedulaBuscar ENDP

Codigo EndS
    END