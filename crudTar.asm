;Víctor Esteban Azofeifa Portuguez 2023113603 y Anthony Rodriguez Alpizar 2021120181
;Programa basico de un CRUD de tarjetas de empleados

;includes
include macroPP.asm
;procedimientos
extrn ClearScreenP:Far, GotoXYP:Far, WaitKeyP:Far, print_string:Far, input_string:Far, write_char:Far, write_field_from_buffer:FAR, escribir_en_archivo:far, vaciar_buffer:far, cerrar_archivoP:far, crear_archivoP:far, abrir_archivoP:far

Pila Segment
         db 100 Dup ('?')
Pila EndS

Datos Segment
    menu_msg          db 13,10,'======== MENU ========',13,10
                      db '1. Agregar empleado',13,10
                      db '2. Listar empleados',13,10
                      db '3. Modificar empleado',13,10
                      db '4. Eliminar empleado',13,10
                      db '5. Salir',13,10
                      db 'Opcion: $'

    ;mensajes comunes (compartidos)
    msg_empresa       db 13,10,13,10,'Empresa: (20 char max)  $'
    msg_nombre        db 13,10,'Nombre: (45 char max)  $'
    msg_cedula        db 13,10,'Cedula: (12 char max)  $'
    msg_telefono      db 13,10,'Telefono: (15 char max)  $'
    msg_email         db 13,10,'Email: (35 char max)  $'
    msg_pregunta      db 13,10,13,10,'Ingresar otro? (s/n):  $'
    msg_error         db 13,10,'Error en archivo...$'
    msg_no_archivo    db 13,10,'Problema con el archivo...$'
    msg_listando      db 13,10,'--- LISTA DE EMPLEADOS ---',13,10,'$'
    msg_guardado      db 13,10,'Empleado guardado...$'
    msg_modificado    db 13,10,'Empleado modificado...$'
    msg_eliminado     db 13,10,'Empleado eliminado...$'
    msg_buscar_cedula db 13,10,'Introduzca la cedula: $'
    msg_not_found     db 13,10,'El empleado no existe $'



    ;buffers de entrada: [max_len][actual_len][datos...]
    ;IMPORTANTE: Usamos DUP(0) para evitar basura
    buf_opcion        db 3, 0, 3 DUP(0)
    buf_empresa       db 41, 0, 41 DUP(0)
    buf_nombre        db 41, 0, 41 DUP(0)
    buf_cedula        db 41, 0, 41 DUP(0)
    buf_telefono      db 41, 0, 41 DUP(0)
    buf_email         db 41, 0, 41 DUP(0)
    buf_respuesta     db 3, 0, 3 DUP(0)

    ;archivo
    filename          db 'empleado.txt', 0
    temp_file         db 'temp.txt', 0
    rename_file       db 'temp.txt',0,'empleado.txt',0
    handle            dw ?
    handle_temp       dw ?
    len_archivo       dw ?
    out_ptr           dw ?

    cont_empleados    dw ?
    cedula_buscar     db 41, 0, 41 DUP(0)
    buffer_lectura    db 4096 DUP(0)
    out_buffer        db 4096 DUP(0)
    out_buffer_fin    dw ?                                               ; fin del out buffer
    cr_lf             db 13,10,'$'                                       ; salto de linea DOS
    coma              db ','
    separacion        db '/'

    ;mis variables
    cont_comas        db ?                                               ; contador de comas
    cont_slash        db ?                                               ; contador de slashes
    buf_encontrada    db 41 dup(0)                                       ; Buffer para guadar cédulas encontradas
    len_empleado      db ?                                               ; longitud del empleado
    found             db ?                                               ; Indicador si encontró la cédula
    cont_aux          db ?                                               ; contador para caso espacial
    
    
Datos EndS

Codigo Segment
                          Assume         CS:Codigo, SS:Pila, DS:Datos
    Inicio:               
    ;inicializacion Datos Segment
                          xor            ax,ax
                          mov            ax,Datos
                          mov            ds,ax

    menu_principal:       
    ;Menu principal
                          mov            cont_comas, 0                       ; reiniciar para futuras iteraciones
                          mov            cont_slash,0
                          mov            len_empleado,0
                          mov            found, 0

                          lea            dx, menu_msg
                          push           dx
                          call           print_string
    ;leer opcion
                          lea            dx, buf_opcion
                          push           dx
                          call           input_string
                          mov            cont_empleados,0

    ;limpiar pantalla y redireccionar cursor
                          mov            bh,0fh                              ; da color blanco a la pantalla
                          xor            cx,cx                               ; pone en 0 ch y cl
                          mov            dh,24                               ; fila inferior
                          mov            dl,79                               ; columna inferior
                          pushA
                          call           ClearScreenP                        ; limpiar pantalla
                          xor            dx,dx                               ; poner en 0 dh y dl para redireccionar cursor a 0,0
                          call           GotoXYP                             ; redireccionar cursor a 0,0

    ;procesar opcion
                          mov            al, [buf_opcion + 2]
                          cmp            al, '1'
                          je             agregar_empleado
                          cmp            al, '2'
                          je             puenteListar
                          cmp            al, '3'
                          je             puenteModificar
                          cmp            al, '4'
                          je             puenteEliminar
                          cmp            al, '5'
                          je             puenteSalir
                          jmp            menu_principal

    ;proceso para leer datos del empleado
    agregar_empleado:     
    ; Leer datos
                          input_buffersM msg_empresa, buf_empresa
                          input_buffersM msg_nombre, buf_nombre
                          input_buffersM msg_cedula, buf_cedula
                          input_buffersM msg_telefono, buf_telefono
                          input_buffersM msg_email, buf_email

                          inc            cont_empleados
                          cmp            cont_empleados, 1
                          jg             mover_al_final
                          jmp            short abrir_archivo
    ;puentes
    puenteListar:         
                          jmp            listar_empleados
    puenteModificar:      
                          jmp            puenteModificar1
    puenteEliminar:       
                          jmp            puenteEliminar1
    puenteSalir:          
                          jmp            salir_programa

    ; Abrir archivo (modo lectura/escritura)
    abrir_archivo:        
                          lea            dx, filename
                          mov            ax, 3D02h
                          push           dx
                          push           ax
                          call           abrir_archivoP
                          jc             crear_archivo
                          mov            handle, ax
                          jmp            mover_al_final



    crear_archivo:        
                          lea            dx, filename
                          push           dx
                          call           crear_archivoP
                          jc             puenteErrorArchivo1
                          mov            handle, ax
                          jmp            escribir_empleado

    ;mover puntero al final del archivo
    mover_al_final:       
                          mov            bx, handle
                          mov            ax, 4202h                           ; Mover al final (EOF)
                          xor            cx, cx
                          xor            dx, dx
                          int            21h

    ;escribir empleado en archivo
    escribir_empleado:    
    ; Verificar que handle sea válido (bx = handle)
    ; Escribir empresa
                          mov            bx, handle

                          lea            si, buf_empresa
                          mov            dx,offset coma
                          push           si
                          push           dx
                          call           escribir_en_archivo
        

                          lea            si, buf_nombre
                          mov            dx,offset coma
                          push           si
                          push           dx
                          call           escribir_en_archivo

                          lea            si, buf_opcion
                          mov            dl, [si+2]
                          cmp            dl, '3'
                          je             agregar_modificar

                          
                          lea            si, buf_cedula
                          mov            dx,offset coma
                          push           si
                          push           dx
                          call           escribir_en_archivo
                          jmp            siga_agregar

    ; EN caso que la opcion sea modificar, se agrega la cedula que se está buscando
    agregar_modificar:    
                          lea            si, cedula_buscar
                          mov            dx,offset coma
                          push           si
                          push           dx
                          call           escribir_en_archivo

                          jmp            short siga_agregar
    puenteErrorArchivo1:  
                          jmp            puenteErrorArchivo

    siga_agregar:         
                          lea            si, buf_telefono
                          mov            dx,offset coma
                          push           si
                          push           dx
                          call           escribir_en_archivo

                          lea            si, buf_email
                          mov            dx,offset separacion
                          push           si
                          push           dx
                          call           escribir_en_archivo
    
                          lea            si, buf_opcion                      ; COmprobar si está en una iteración de modificar
                          mov            bl, [si+2]
                          cmp            bl, '3'
                          je             puenteModificar3

                          jmp            short siga

    puenteAgregarEmpleado:
                          jmp            agregar_empleado
    puenteErrorArchivo:   
                          jmp            error_archivo

    siga:                 
    ;mensaje empleado guardado
                          lea            dx, msg_guardado
                          push           dx
                          call           print_string
                          call           WaitKeyP


    ;limpiar pantalla y redireccionar cursor
                          mov            bh,0fh                              ; da color blanco a la pantalla
                          xor            cx,cx                               ; pone en 0 ch y cl
                          mov            dh,24                               ; fila inferior
                          mov            dl,79                               ; columna inferior
                          pushA
                          call           ClearScreenP                        ; limpiar pantalla
                          xor            dx,dx                               ; poner en 0 dh y dl para redireccionar cursor a 0,0
                          call           GotoXYP                             ; redireccionar cursor a 0,0

    ; ¿Agregar otro?
    agregar_otro:         
                          lea            dx, msg_pregunta
                          push           dx
                          call           print_string
                          lea            dx, buf_respuesta
                          push           dx
                          call           input_string
                          mov            al, [buf_respuesta + 2]
                          cmp            al, 's'
                          je             puenteAgregarEmpleado
                          cmp            al,'n'
                          je             cerrar_archivo
                          jmp            agregar_otro

    ; Cerrar archivo
    cerrar_archivo:       
                          mov            bx, handle
                          push           bx
                          call           cerrar_archivoP
                          mov            al, [buf_opcion + 2]
                          cmp            al,'5'
                          je             puenteSalir1
                          jmp            menu_principal

    puenteEliminar1:      
                          jmp            eliminar_empleado
    puenteModificar1:     
                          jmp            puenteModificar2
    puenteModificar3:     
                          jmp            siga_modificar2

    ;listar empleados
    listar_empleados:     
                          lea            dx, msg_listando
                          push           dx
                          call           print_string
    ; vaciar buffer_lectura por si acaso
                          mov            dx, offset buffer_lectura
                          pushA
                          push           dx
                          call           vaciar_buffer
                          popA
    ; Abrir archivo en modo solo lectura
                          lea            dx, filename
                          MOV            ax, 3D00H
                          push           dx
                          push           ax
                          call           abrir_archivoP
                          jc             puente_no_existe

                          mov            handle, ax
    
    ; Lee el número total de bytes que leyó en el archivo
    leer_bucle:           
                          mov            bx, handle
                          mov            cx, 4096                            ; número de bytes que desea leer
                          lea            dx, buffer_lectura                  ; acá se guardan los bytes leídos
                          mov            ah, 3Fh                             ; Leer desde archivo
                          int            21h

                          cmp            ax, 0                               ; ¿Fin del archivo?
                          je             fin_lectura

    ; Imprimir los ax bytes leídos
                          mov            cx, ax
                          lea            si, buffer_lectura
    imprimir_bucle:       
                          lodsb
                          mov            dl,al
                          cmp            dl,'/'
                          je             enter
                          mov            ah, 02h                             ; Imprimir carácter
                          int            21h
                          loop           imprimir_bucle

                          jmp            leer_bucle

    enter:                
                          lea            dx, cr_lf
                          push           dx
                          call           print_string
                          jmp            short imprimir_bucle
    fin_lectura:          
                          mov            bx, handle
                          push           bx
                          call           cerrar_archivoP
                          jmp            cerrar_archivo

    puenteSalir1:         
                          jmp            salir_programa
    puente_no_existe:     
                          jmp            no_existe

    puenteModificar2:     
                          jmp            modificar_empleado
    ;eliminar empleado
    eliminar_empleado:    
    ; Leer datos
                          input_buffersM msg_buscar_cedula, cedula_buscar
    ; vaciar buffer de lectur
                          mov            dx, offset buffer_lectura
                          push           dx
                          call           vaciar_buffer
    ; Abrir archivo original en modo solo lectura
                          lea            dx, filename
                          mov            ax, 3D00H
                          push           dx
                          push           ax
                          call           abrir_archivoP


                          jc             puente_no_existe
                          mov            handle, ax
    
    ; Leer todo el archivo y copiar a buffer
                          mov            bx, handle
                          mov            cx, 4096
                          lea            dx, buffer_lectura
                          mov            ah, 3Fh
                          int            21h

                          jc             puente_no_existe
                          mov            len_archivo, ax

    ; Cerrar archivo de origen
                          mov            bx, handle
                          push           bx
                          call           cerrar_archivoP

    ;Leer el buffer y buscar las cédulas
                          mov            ax, len_archivo                     ; en caso que se haya perdido
                          mov            cx, ax
                          push           ax                                  ; guardar la cantidad de bytes leìdos
                          lea            si, buffer_lectura
    buscar_cedula:        
                          lodsb
                          inc            len_empleado
                          cmp            al,','
                          je             coma_encontrada
                          cmp            al,'/'
                          je             slash_encontrado
    siga_buscar:          
                          loop           buscar_cedula
                          lea            dx, msg_not_found
                          push           dx
                          call           print_string
                          jmp            menu_principal
    siga_pop:             
                          pop            si                                  ; recuerar el puntero para lodsb
                          mov            cont_aux, 0                         ; reinicar el contador auxiliar
                          loop           buscar_cedula

    slash_encontrado:     
                          cmp            found,1                             ; comprabar si se encontró la cédula indicada
                          je             eliminar
                          mov            cont_comas,0                        ; reiniciar contador de comas
                          mov            len_empleado,0                      ; reiniciar el incremento
                          inc            cont_slash
                          jmp            short siga_buscar
    coma_encontrada:      
                          inc            cont_comas
                          cmp            cont_comas,2
                          jne            siga_buscar                         ; continuar el bucle de donde lo dejó
                          push           si                                  ; guardar la direcciòn actual en bufer lectura
                          lea            di,buf_encontrada
    
    cedula_encontrada:    
                          mov            bl, [si]
                          cmp            bl, ','
                          je             comparacion_cedulas
                          inc            cont_aux
                          mov            [di], bl
                          inc            di
                          inc            si
                          jmp            short cedula_encontrada
                    
    comparacion_cedulas:  
                          mov            bl, [cedula_buscar + 1]             ; Contiene la cédula ingresada
                          cmp            cont_aux,bl
                          jne            siga_pop
                          mov            cont_aux,bl
    
    ; SI longitudes son iguales moverse por los buffers para comarar su contenido
    ;mov    cont_aux,bx
                          lea            si, 2[cedula_buscar]                ;cedula buscada
                          lea            di, [buf_encontrada]                ; cedula actual
    contenido:            
                          mov            bl, [si]
                          mov            dl, [di]
                          cmp            bl,dl
                          jne            siga_pop
                          inc            di
                          inc            si
                          dec            cont_aux
                          cmp            cont_aux,0
                          jne            contenido
                            
                          mov            found,1
                            
                          jmp            siga_pop
    puente_eliminar1:     
                          jmp            eliminar_empleado
    ; eliminar al empleado del buffer que se pasará a temp
    eliminar:             
                          pop            ax                                  ; recuperar la cantidad de bytes leìdos en buffer_leacutra
                          mov            cx,ax
                          lea            si, buffer_lectura
                          lea            di, out_buffer
                          mov            cont_aux,0                          ; reinicar el contador y usarlo para contar '/'
                          mov            bh, cont_slash
                          xor            dx,dx
    copiar_contenido:     
                          cmp            bh, cont_aux
                          jne            siga_copiar

                          mov            dl, len_empleado
                          add            si, dx                              ; le suma la longitud del empleado eliminado
                          inc            cont_aux                            ; evita que siga incrementadno el si
    siga_copiar:          
                          mov            bl,[si]
                          cmp            bl, 00h
                          je             copiar_temp
                          cmp            bl, '/'
                          jne            siga_copiar2
                          inc            cont_aux
    siga_copiar2:         
                          mov            [di],bl
                          inc            di
                          inc            si
                          loop           copiar_contenido

    copiar_temp:          
                          mov            [out_buffer_fin], di
                                                    
    ; Crear archivo temporal
                          lea            dx, temp_file
                          push           dx
                          call           crear_archivoP
                          jc             puente_error
                          mov            handle_temp, ax
    ; escribir out_buffer en temp.txt
                          mov            ah,40h
                          mov            bx,handle_temp
                          mov            cx,out_buffer_fin
                          mov            dx,offset out_buffer
                          sub            cx,dx
                          int            21h

    ; Cerrar archivo temporal
                          mov            bx, handle_temp
                          push           bx
                          call           cerrar_archivoP
   
    ;borrar archivo original y renombrar temporal
                          lea            dx, filename
                          mov            ah,41h
                          int            21h

                          push           ds
                          pop            es
    
                          lea            dx, temp_file
                          mov            di, offset filename
                          mov            ah,56h                              ;renombrar archivo temp a empleado
                          int            21h
                          
    ; verificar si es iteración de modificar
                          lea            si, buf_opcion
                          mov            bl, [si+2]
                          cmp            bl, '3'
                          je             siga_modificar
    

                          lea            dx, msg_eliminado
                          push           dx
                          call           print_string


                          jmp            menu_principal
    puente_error:         
                          jmp            error_archivo
    modificar_empleado:   
    ; Preguntar por cedula y eliminar en caso de encontrarlo
                          jmp            eliminar_empleado

    siga_modificar:       
    ; preguntar por nuevos datos
                          input_buffersM msg_empresa, buf_empresa
                          input_buffersM msg_nombre, buf_nombre
                          input_buffersM msg_telefono, buf_telefono
                          input_buffersM msg_email, buf_email
    
    ; agregar empleado con misma cedula y nuevos datos
    ; Abrir el archivo y mover el cursor al final
                          lea            dx, filename
                          mov            ax, 3D02h
                          push           dx
                          push           ax
                          call           abrir_archivoP

                          mov            handle, ax
                          jmp            mover_al_final
    siga_modificar2:      
                          lea            dx, msg_modificado
                          push           dx
                          call           print_string
                          call           WaitKeyP
    ; cerrrar el archivo
                          mov            bx, handle
                          push           bx
                          call           cerrar_archivoP

                          jmp            menu_principal

                            
    no_existe:            
                          lea            dx, msg_no_archivo
                          push           dx
                          call           print_string
                          jmp            menu_principal

    salir_programa:       

                          mov            ah, 4Ch
                          int            21h

    error_archivo:        
                          lea            dx, msg_error
                          push           dx
                          call           print_string
                          jmp            menu_principal


Codigo EndS
End Inicio