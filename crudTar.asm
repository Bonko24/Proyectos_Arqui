;Víctor Esteban Azofeifa Portuguez 2023113603 y Anthony Rodriguez Alpizar 2021120181
;Programa basico de un CRUD de tarjetas de empleados

;includes
include macroPP.asm
;procedimientos
extrn ClearScreenP:Far, GotoXYP:Far, WaitKeyP:Far, print_string:Far, input_string:Far, write_comma:Far, write_backSlash:Far

Pila Segment
    db 100 Dup ('?')
Pila EndS

Datos Segment
    menu_msg        db 13,10,'======== MENU ========',13,10
                    db '1. Agregar empleado',13,10
                    db '2. Listar empleados',13,10
                    db '3. Modificar empleado',13,10
                    db '4. Eliminar empleado',13,10
                    db '5. Salir',13,10
                    db 'Opcion: $'

    ;mensajes comunes (compartidos)
    msg_empresa     db 13,10,13,10,'Empresa: (20 char max)  $'
    msg_nombre      db 13,10,'Nombre: (45 char max)  $'
    msg_cedula      db 13,10,'Cedula: (12 char max)  $'
    msg_telefono    db 13,10,'Telefono: (15 char max)  $'
    msg_email       db 13,10,'Email: (35 char max)  $'
    msg_pregunta    db 13,10,13,10,'Ingresar otro? (s/n):  $'
    msg_error       db 13,10,'Error en archivo...$'
    msg_no_archivo  db 13,10,'Problema con el archivo...$'
    msg_listando    db 13,10,'--- LISTA DE EMPLEADOS ---',13,10,'$'
    msg_guardado    db 13,10,'Empleado guardado...$'
    msg_modificado  db 13,10,'Empleado modificado...$'
    msg_eliminado   db 13,10,'Empleado eliminado...$'

    ;buffers de entrada: [max_len][actual_len][datos...]
    ;IMPORTANTE: Usamos DUP(0) para evitar basura
    buf_opcion    db 3, 0, 3 DUP(0)
    buf_empresa   db 41, 0, 41 DUP(0)
    buf_nombre    db 41, 0, 41 DUP(0)
    buf_cedula    db 41, 0, 41 DUP(0)
    buf_telefono  db 41, 0, 41 DUP(0)
    buf_email     db 41, 0, 41 DUP(0)
    buf_respuesta db 3, 0, 3 DUP(0)

    ;archivo
    filename       db 'empleado.txt', 0
    temp_file      db 'temp.txt', 0
    rename_file    db 'temp.txt',0,'empleado.txt',0
    handle         dw ?
    handle_temp    dw ?
    len_archivo    dw ?
    out_ptr        dw ?

    cont_empleados dw ?
    cedula_buscar  db 41, 0, 41 DUP(0)
    buffer_lectura db 4096 DUP(0)
    out_buffer     db 4096 DUP(0)
    cr_lf          db 13,10,'$'              ; salto de linea DOS
    coma           db ','
    separacion     db '/'
Datos EndS

Codigo Segment
    Assume CS:Codigo, SS:Pila, DS:Datos
Inicio:
    ;inicializacion Datos Segment
    xor ax,ax
    mov ax,Datos
    mov ds,ax

    menu_principal:
        ;Menu principal
        lea dx, menu_msg
        push dx
        call print_string
        ;leer opcion
        lea dx, buf_opcion
        push dx
        call input_string
        mov cont_empleados,0

        ;limpiar pantalla y redireccionar cursor
            mov bh,0fh                      ; da color blanco a la pantalla
            xor cx,cx                       ; pone en 0 ch y cl
            mov dh,24                       ; fila inferior
            mov dl,79                       ; columna inferior
            pushA                     
            call ClearScreenP               ; limpiar pantalla
            xor dx,dx                       ; poner en 0 dh y dl para redireccionar cursor a 0,0
            call GotoXYP                    ; redireccionar cursor a 0,0

        ;procesar opcion
        mov al, [buf_opcion + 2]
        cmp al, '1'
        je agregar_empleado
        cmp al, '2'
        je puenteListar
        ;cmp al, '4'
        ;je puenteEliminar
        cmp al, '5'
        je puenteSalir
        jmp menu_principal

    ;proceso para leer datos del empleado
    agregar_empleado:
        ; Leer datos
        lea dx, msg_empresa
        push dx
        call print_string
        lea dx, buf_empresa
        push dx
        call input_string

        lea dx, msg_nombre
        push dx
        call print_string
        lea dx, buf_nombre
        push dx
        call input_string

        lea dx, msg_cedula
        push dx
        call print_string
        lea dx, buf_cedula
        push dx
        call input_string

        lea dx, msg_telefono
        push dx
        call print_string
        lea dx, buf_telefono
        push dx
        call input_string

        lea dx, msg_email
        push dx
        call print_string
        lea dx, buf_email
        push dx
        call input_string
        inc cont_empleados
        cmp cont_empleados, 1
        jg mover_al_final

        ; Abrir archivo (modo lectura/escritura)
        abrir_archivo:
        lea dx, filename
        mov ax, 3D02h
        int 21h
        jc crear_archivo
        mov handle, ax
        jmp mover_al_final

;puentes
puenteListar:
    jmp listar_empleados
;puenteEliminar:
;    jmp puenteEliminar1
puenteSalir:
    jmp salir_programa

    crear_archivo:
        lea dx, filename
        mov cx, 0
        mov ah, 3Ch
        int 21h
        jc puenteErrorArchivo
        mov handle, ax
        jmp escribir_empleado

    ;mover puntero al final del archivo
    mover_al_final:
        mov bx, handle
        mov ax, 4202h               ; Mover al final (EOF)
        xor cx, cx
        xor dx, dx
        int 21h

    ;escribir empleado en archivo
    escribir_empleado:
        ; Verificar que handle sea válido (bx = handle)
        ; Escribir empresa
        lea si, buf_empresa
        call write_field_from_buffer
        mov bx, handle
        push bx
        mov dx,offset coma
        push dx
        call write_comma

        lea si, buf_nombre
        call write_field_from_buffer
        mov bx, handle
        push bx
        mov dx,offset coma
        push dx
        call write_comma

        lea si, buf_cedula
        call write_field_from_buffer
        mov bx, handle
        push bx
        mov dx,offset coma
        push dx
        call write_comma

        lea si, buf_telefono
        call write_field_from_buffer
        mov bx, handle
        push bx
        mov dx,offset coma
        push dx
        call write_comma

        lea si, buf_email
        call write_field_from_buffer
        mov bx, handle
        push bx
        mov dx,offset separacion
        push dx
        call write_backSlash
        jmp short siga

puenteAgregarEmpleado:
    jmp agregar_empleado
puenteErrorArchivo:
    jmp error_archivo

        siga:
            ;mensaje empleado guardado
            lea dx, msg_guardado
            push dx
            call print_string
            call WaitKeyP


            ;limpiar pantalla y redireccionar cursor
            mov bh,0fh                  ; da color blanco a la pantalla
            xor cx,cx                   ; pone en 0 ch y cl
            mov dh,24                   ; fila inferior
            mov dl,79                   ; columna inferior
            pushA                     
            call ClearScreenP           ; limpiar pantalla
            xor dx,dx                   ; poner en 0 dh y dl para redireccionar cursor a 0,0
            call GotoXYP                ; redireccionar cursor a 0,0

        ; ¿Agregar otro?
        agregar_otro:
        lea dx, msg_pregunta
        push dx
        call print_string
        lea dx, buf_respuesta
        push dx
        call input_string
        mov al, [buf_respuesta + 2]
        cmp al, 's'
        je puenteAgregarEmpleado
        cmp al,'n'
        je cerrar_archivo
        jmp agregar_otro
; --------------------------------------------
    ; Cerrar archivo
        cerrar_archivo:
        mov bx, handle
        mov ah, 3Eh
        int 21h
        mov al, [buf_opcion + 2]
        cmp al,'5'
        je puenteSalir1
        jmp menu_principal

;puenteEliminar1:
;    jmp eliminar_empleado

    ;listar empleados
    listar_empleados:
        lea dx, msg_listando
        push dx
        call print_string

        ; Abrir archivo en modo solo lectura
        lea dx, filename
        mov ax, 3D00h
        int 21h
        jc puente_no_existe

        mov handle, ax

    leer_bucle:
        mov bx, handle
        mov cx, 4096
        lea dx, buffer_lectura
        mov ah, 3Fh                 ; Leer desde archivo
        int 21h

        cmp ax, 0                   ; ¿Fin del archivo?
        je fin_lectura

        ; Imprimir los ax bytes leídos
        mov cx, ax
        lea si, buffer_lectura
    imprimir_bucle:
        lodsb
        mov dl,al 
        cmp dl,'/'
        je enter
        mov ah, 02h                 ; Imprimir carácter
        int 21h
        loop imprimir_bucle

        jmp leer_bucle

        enter:
        lea dx, cr_lf
        push dx
        call print_string
        jmp short imprimir_bucle

    fin_lectura:
        mov bx, handle
        mov ah, 3Eh
        int 21h
        jmp cerrar_archivo

puenteSalir1:
    jmp salir_programa
puente_no_existe:
    jmp no_existe

    ;eliminar empleado
    ;eliminar_empleado:
    ;    ; Leer datos
    ;    lea dx, msg_cedula
    ;    push dx
    ;    call print_string
    ;    lea dx, cedula_buscar
    ;    push dx
    ;    call input_string
;
    ;    ; Abrir archivo original en modo solo lectura
    ;    lea dx, filename
    ;    mov ax, 3D00h
    ;    int 21h
    ;    jc puente_no_existe
    ;    mov handle, ax
;
    ;    ; Leer todo el archivo y copiar a buffer
    ;    mov bx, handle
    ;    mov cx, 4096
    ;    lea dx, buffer_lectura
    ;    mov ah, 3Fh
    ;    int 21h
    ;    jc puente_no_existe
    ;    mov len_archivo, ax
;
    ;    ; Cerrar archivo original
    ;    mov bx, handle
    ;    mov ah, 3Eh
    ;    int 21h
;
    ;    ; Crear archivo temporal
    ;    lea dx, temp_file
    ;    mov ah, 3Ch
    ;    mov cx, 0
    ;    int 21h
    ;    jc puente_no_existe
    ;    mov handle_temp, ax
;
    ;    ; Procesar buffer
    ;    lea si, buffer_lectura
    ;    mov di,si
    ;    add di,len_archivo          ;di apunta al final del buffer  
    ;    xor bx,bx                   ;bx es el indice del buffer
;
    ;    procesar_bucle: 
    ;        cmp si,di
    ;        jge puente_fin_procesar
;
    ;        ;buscar fin del registro (o '/')
    ;        mov cx,si
    ;        mov ax,si
    ;        sub ax,bx               ;ax = longitud del registro actual sin verificar
;
    ;        buscar_barra:
    ;            cmp si,di
    ;            jge sin_barra
    ;            cmp byte ptr [si],'/'
    ;            je encontrado_barra
    ;            inc si
    ;            jmp buscar_barra
;
    ;            sin_barra:
    ;                ;ultimo registro sin barra
    ;                mov si,di
;
    ;            encontrado_barra:
    ;            ;ahora [bx .. si-1] es el registro completo
    ;            ;extraer cedula del registro (buscar coma)
    ;            push si
    ;            push di
    ;            mov di,bx
    ;            xor cx,cx            ;cx es el indice dentro del registro actual (contador de comas)
;
    ;            buscar_coma:
    ;                cmp di,si
    ;                jge no_encontrada
    ;                cmp byte ptr [di],','
    ;                jge no_es_coma
    ;                inc cx
    ;                cmp cx,2
    ;                je cedula_inicio
;
    ;                no_es_coma:
    ;                    inc di
    ;                    jmp buscar_coma
;
    ;                    cedula_inicio:
    ;                        inc di  ;di apuntando al inicio de la cedula
    ;                        push di 
    ;                        lea si, cedula_buscar
    ;                        xor cx,cx
;
    ;                        comparar_cedula:
    ;                            ; comparar byte a byte hasta ',' o fin de registro
    ;                            cmp di,[bp-2]
    ;                            cmp byte ptr [di],','
    ;                            je cedula_fin_barra
    ;                            cmp byte ptr [si],0
    ;                            je ced_fin_cero
    ;                            mov al,[di]
    ;                            cmp al,[si]
    ;                            jne cedula_distinta
    ;                            inc di
    ;                            inc si
    ;                            jmp comparar_cedula
    ;                        
    ;    puente_fin_procesar:
    ;        jmp fin_procesar
;
    ;                    cedula_fin_barra:
    ;                        cmp byte ptr [si],0
    ;                        jne cedula_distinta
    ;                        jmp cedula_coincide
;
    ;                    ced_fin_cero:
    ;                        cmp byte ptr [di],','
    ;                        jne cedula_distinta
    ;                        jmp cedula_coincide
;
    ;                    cedula_distinta:
    ;                        pop di          ;limpiar pila
    ;                        jmp copiar_registro
;
    ;                    cedula_coincide:
    ;                        pop di          ;limpiar pila
    ;                        ;coincide -> no copiar registro
    ;                        pop di
    ;                        pop si
    ;                        inc si         ;si apunta al inicio del siguiente registro (saltar la '/')
    ;                        mov bx,si
    ;                        jmp procesar_bucle
;
    ;                no_encontrada:
    ;                    ;no se encontro la cedula en el registro
    ;                    pop di
    ;                    pop si
;
    ;        copiar_registro:
    ;            pop di
    ;            pop si
    ;            ;copiar registro [bx .. si] al out buffer
    ;            lea dx, out_buffer
    ;            add di, out_ptr
    ;            mov cx, si
    ;            sub cx, bx
    ;            lea si,buffer_lectura
    ;            add si,bx
    ;            rep movsb
    ;            mov out_ptr,di
    ;            sub out_ptr,offset out_buffer
;
    ;            ;agregar barra al final
    ;            cmp si,len_archivo
    ;            je no_copiar_barra
    ;            mov al,'/'
    ;            mov [di],al
    ;            inc out_buffer
    ;            no_copiar_barra:
    ;            inc si
    ;            mov bx,si
    ;            jmp procesar_bucle
;
    ;    fin_procesar:
    ;        ;escribir out_ptr en archivo temporal
    ;        mov cx, out_ptr
    ;        cmp cx,0
    ;        je cerrar_temp
    ;        mov bx, handle_temp
    ;        lea dx, out_buffer
    ;        mov ah, 40h
    ;        int 21h
    ;        jc no_existe
    ;    
    ;    cerrar_temp:
    ;        mov bx, handle_temp
    ;        mov ah, 3Eh
    ;        int 21h
;
    ;        ;borrar archivo original y renombrar temporal
    ;        lea dx, filename
    ;        mov ah,41h
    ;        int 21h
;
    ;        lea dx, temp_file
    ;        mov di, offset filename
    ;        mov ah,56h              ;renombrar archivo temp a empleado 
    ;        int 21h

    no_existe:
        lea dx, msg_no_archivo
        push dx
        call print_string
        jmp menu_principal

salir_programa:

    mov ah, 4Ch
    int 21h

    error_archivo:
        lea dx, msg_error
        push dx
        call print_string
        jmp menu_principal

;---------------------------------------------------------Hasta Aca llega el Codigo
;escribe en el archivo el campo que esta en el buffer
    write_field_from_buffer PROC
        pushA
        mov bl, [si + 1]
        xor bh, bh
        cmp bx, 0
        je fin
        mov cx, bx
        mov dx, si
        add dx, 2
        mov bx, handle      ; ← ¡handle debe estar aquí!
        mov ah, 40h
        int 21h
    fin:
        popA
        ret
    write_field_from_buffer ENDP

Codigo EndS
End Inicio