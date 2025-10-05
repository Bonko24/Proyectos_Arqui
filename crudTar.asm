;Anthony Rodriguez 2021120181 | Esteban Azofeifa 
;Programa basico de un CRUD de tarjetas de empleados

;---------------------------------------------------------
;Para compilar usar:
;1) tener el archivo compilar.bat en la misma carpeta que los archivos .asm
;2) copiar esto en el DosBox: compilar crudTar empleados
;3) td crudTar (debugear)  o  crudTar (ejecutar)
;--------------------------------------------------------- 

;buffers definidos en empleados.asm pero accesibles
extrn inputBuf:BYTE, newEmpresa:BYTE ,newNombre:BYTE ,newCedula:BYTE ,newEmail:BYTE ,newPuesto:BYTE ,newTelefono:BYTE ,newTiempo:BYTE
;procedimientos
extrn InicializarDS:Far, ClearScreenP:Far, PrintString:Far, leerLinea:PROC ,copiarInputDestino:PROC ,copiarCedulaBuscar:PROC

Pila Segment
    db 100 Dup ('?')
Pila EndS

Datos Segment
    menuMsg     DB 13,10,'=== CRUD Empleados ===',13,10
                DB '1. Crear',13,10
                DB '2. Leer',13,10
                DB '3. Actualizar',13,10
                DB '4. Eliminar',13,10
                DB '5. Salir',13,10
                DB 'Opcion: $'

    empresaMsg  DB 13,10,'Empresa: $'
    nombreMsg   DB 13,10,'Nombre: $'
    cedulaMsg   DB 13,10,'Cedula: $'
    emailMsg    DB 13,10,'Email: $'
    puestoMsg   DB 13,10,'Puesto: $'
    telefonoMsg DB 13,10,'Telefono: $'
    tiempoMsg   DB 13,10,'Tiempo en empresa (años): $'
    updateMsg   DB 13,10,'--- Nuevos datos ---$'
    enterMsg    DB 13,10,'Presione Enter para continuar...$'

    opcion      DB ?
Datos EndS

Codigo Segment
    Assume CS:Codigo, SS:Pila, DS:Datos

MAIN PROC
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

loopMenu:
    MOV DX, OFFSET menuMsg
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    MOV opcion, AL
    MOV DL, 13
    MOV AH, 02h
    INT 21h
    MOV DL, 10
    INT 21h

    CMP AL, '1'
    JE crear
    CMP AL, '2'
    JE leer
    CMP AL, '3'
    JE actualizar
    CMP AL, '4'
    JE eliminar
    CMP AL, '5'
    JE salir
    JMP loopMenu

crear:
    CALL limpiarCampos
    MOV DX, OFFSET empresaMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newEmpresa
    CALL copiarInputDestino

    MOV DX, OFFSET nombreMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newNombre
    CALL copiarInputDestino

    MOV DX, OFFSET cedulaMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newCedula
    CALL copiarInputDestino

    MOV DX, OFFSET emailMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newEmail
    CALL copiarCedulaBuscar

    MOV DX, OFFSET puestoMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newPuesto
    CALL copiarCedulaBuscar

    MOV DX, OFFSET telefonoMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newTelefono
    CALL copiarCedulaBuscar

    MOV DX, OFFSET tiempoMsg
    MOV AH, 09h
    INT 21h
    PUSH OFFSET newTiempo
    CALL copiarCedulaBuscar

salir:
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

Codigo EndS

limpiarCampos PROC
    PUSH AX
    PUSH CX
    PUSH DI
    XOR AX, AX
    MOV DI, OFFSET newEmpresa
    MOV CX, 31+31+21+41+31+16+6
    REP STOSB
    POP DI
    POP CX
    POP AX
    RET
limpiarCampos ENDP

END MAIN