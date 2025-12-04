;Anthony Rodriguez 2021120181, Esteban Azofeifa 2023113603
;Programa que muestra figuras geometricas por consola
;A peticion del usuario las figuras estaran vacias o rellenas

;---------------------------------------------------------
;Para compilar usar:
;1) tener el archivo compilar.bat en la misma carpeta que los archivos .asm
;2) copiar esto en el DosBox: compilar figuras procFig
;3) td figuras (debugear)  o  figuras (ejecutar)
;--------------------------------------------------------- 
 ;DX: Fila, CX: Columna
;llamadas a procedimientos en proc.asm e include
include macroF.asm
extrn InicializarDS:Far, ClearScreenP:Far, WhereXYP:Far, GotoXYP:Far, PrintCharColorP:Far, PrintCharP:Far, PrintNum:Far, PrintString:Far, ReadKey:Far, WaitKeyP:Far, input_string:Far, EscribirPixelP:Far, LineaHorizontalP:Far, LineaVerticalP:Far, RomboDiagonalAscendenteP:Far,RomboDiagonalDescendenteP:Far, TrianguloDiagonalAscendenteP:Far, TrianguloDiagonalDescendenteP:far, LineaHorizontal2P:Far


Pila Segment
         db 64 Dup ('?')
Pila EndS

Datos Segment
    mensaje       db 10,13,"Desea que las figuras vayan vacias o rellenas? ",10,13,"Opcion:",10,13,"1) Vacias",10,13,"2) Rellenas",10,13,24h
    errorOp       db 10,13,"Error: Opcion invalida, intente de nuevo",  10,13,  "Presione cualquier tecla...",24h
    op            db ?

    fila          dw ?
    columna       dw ?
    ancho         dw ?
    alto          dw ?
    acc           dw ?

    x             dw ?
    y             dw ?
    xc            dw ?
    yc            dw ?
    p             dw ?
    columna_final dw ?


Datos EndS

Codigo Segment
                     Assume        CS:Codigo, SS:Pila, DS:Datos

    Inicio:          
    ;inicializar ds
                     xor           ax,ax
                     mov           ax,Datos
                     mov           ds,ax

    menu:            
    ;limpiar pantalla y redireccionar cursor
                     mov           bh,0fh                           ; da color blanco a la pantalla
                     xor           cx,cx                            ; pone en 0 ch y cl
                     mov           dh,24                            ; fila inferior
                     mov           dl,79                            ; columna inferior
                     pushA
                     call          ClearScreenP                     ; limpiar pantalla
                     xor           dx,dx                            ; poner en 0 dh y dl para redireccionar cursor a 0,0
                     call          GotoXYP                          ; redireccionar cursor a 0,0

    ;mensaje
                     lea           dx,mensaje
                     pushA
                     call          PrintString

    ;leer opcion
                     push          word ptr op
                     pushA
                     call          ReadKey
                     pop           word ptr op
                     pop           bx
                     xor           bx,bx
    

    ;procesar opcion
                     mov           al,op
                     cmp           al, '1'
                     je            Vacias
                     cmp           al, '2'
                     je            puenteRellenas0
                     jmp           menu
    puenteRellenas0: 
                     jmp           puenteRellenas

    Vacias:          
    ;modo grafico
                     mov           ax,0012h
                     int           10h

    ;------------------------------------valores para cuadrado------------------------------------
    ;Linea Horizontal Superior
                     mov           fila,85                          ;fila inicial
                     mov           columna,215                      ;columna inicial
                     mov           cx,125                           ;Longitud de la linea

                     push          cx
                     mov           ax, 0c09h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizonal

    ; Linea vertical Izquierda
                     mov           cx,125                           ;Longitud de la linea

                     push          cx
                     mov           ax, 0c09h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaVerticalP                   ;Dibuja un línea vertical

    ; Linea Horizontal Inferior
                     mov           cx,125                           ;Longitud de la linea
                     mov           fila, 210                        ;fila inicial

                     push          cx
                     mov           ax, 0c09h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizonal

    ; Linea vertical derecha
                     mov           cx,126                           ;cuantas veces se ejecutara la linea
                     mov           fila,85                          ;fila inicial
                     mov           columna, 340                     ;columna inicial

                     push          cx
                     mov           ax, 0c09h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaVerticalP                   ;Dibuja un línea vertical
                     jmp           short siga

    puenteRellenas:  
                     jmp           puenteRellenas1
              
    ;------------------------------------valores para rectangulo------------------------------------
    siga:            
    ; Linea Horizontal Superior
                     mov           fila,55                          ;fila inicial
                     mov           columna,130                      ;columna inicial
                     mov           cx,165                           ;Longitud de la linea

                     push          cx
                     mov           ax, 0c08h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizonal


    ; Linea vertical izquierda
                     mov           cx,50                            ;Longitud de la linea

                     push          cx
                     mov           ax, 0c08h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaVerticalP                   ;Dibuja un línea vertical
                           
    ; Linea horizontal inferior
                     mov           cx,166                           ;Longitud de la linea
                     mov           fila,105                         ;fila inicial

                     push          cx
                     mov           ax, 0c08h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizontal
    ; Linea vertical derecha
                     mov           cx,50                            ;Longitud de la linea
                     mov           fila,55                          ;fila inicial
                     mov           columna,295                      ;columna inicial

                     push          cx
                     mov           ax, 0c08h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaVerticalP                   ;Dibuja un línea vertical

    ;------------------------------------valores para rombo------------------------------------
    ; Diagonal ascendente izquierda
                     mov           fila,120                         ;fila inicial
                     mov           columna,177                      ;columna inicial
                     mov           cx,25                            ;longitud de la línea

                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalAscendenteP         ;Dibuja un línea diagonal ascendente
                           
    ; Diagonal descendiente derecha
                     mov           cx,25                            ;longitud de la línea

                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalDescendenteP        ;Dibuja un línea diagonal descendente

    ; Diagonal descendiente izquierda
                     mov           fila, 145                        ;fila inicial
                     mov           columna, 152                     ;columna inicial
                     mov           cx,25                            ;longitud de la línea

                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalDescendenteP        ;Dibuja un línea diagonal descendente

    ; Diagonal ascendente derecha
                     mov           columna,202                      ;columna inicial
                     mov           cx,25                            ;longitud de la línea

                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalAscendenteP         ;Dibuja un línea diagonal ascendente

                     jmp           short siga1

    puenteRellenas1: 
                     jmp           puenteRellenas2

    siga1:           
    ;------------------------------------valores para triangulo------------------------------------
    ; Diagonal Ascendente
                     mov           fila,105                         ;fila inicial
                     mov           columna,145                      ;columna inicial
                     mov           cx,42                            ;longitud del lado

                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          TrianguloDiagonalAscendenteP     ;Dibuja un línea diagonal ascendente
    ; Diagonal descendiente
                     mov           cx,42                            ;longitud del lado

                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          TrianguloDiagonalDescendenteP    ;Dibuja un línea diagonal descendente
    
    ; Lineas de relleno diagonales
    ; Diagonal ascendente
                     inc           fila                             ;fila inicial
                     mov           cx,42                            ;cuantas veces se ejecutara la linea

                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          TrianguloDiagonalAscendenteP     ;Dibuja un línea diagonal ascendente
    ; Diagonal descendiente
                     mov           cx,42                            ;longitud del lado

                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          TrianguloDiagonalDescendenteP    ;Dibuja un línea diagonal descendente

    ; Lado Horizontal
                     mov           fila, 189                        ; fila inicial
                     mov           columna, 103
                     mov           cx,84                            ;longitud del lado
                           
                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizontal

    ;------------------------------------valores para círculo------------------------------------
                     mov           x, 0
                     mov           y, 50                            ; y =  radio
                     mov           p, -49                           ; p = 1 - radio
                     mov           xc, 170
                     mov           yc, 215
                     mov           columna,0
                     mov           fila,0
    bucle_circulo:   
    ; Condición del bucle: x <= y
                     mov           ax,x
                     cmp           ax,y
                     jg            puente_circulo
                     jmp           short dibujar_octantes
    puente_circulo:  
                     jmp           fin_circulo
    dibujar_octantes:
    ; Octante 1: (xc+x,yc+y)
                     xor           ax,ax
                     mov           ax,xc
                     add           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     add           ax,y
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h

    ; Octante 2: (xc+y,yc+x)
                     xor           ax,ax
                     mov           ax,xc
                     add           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     add           ax,x
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h

    ; Octante 3: (xc-y,yc+x)
                     xor           ax,ax
                     mov           ax,xc
                     sub           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     add           ax,x
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h
    ; Octante 4: (xc-x,yc+y)
                     xor           ax,ax
                     mov           ax,xc
                     sub           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     add           ax,y
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h
                     
    ; Octante 5: (xc-x,yc-y)
                     xor           ax,ax
                     mov           ax,xc
                     sub           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,y
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h

    ; Octante 6: (xc-y,yc-x)
                     xor           ax,ax
                     mov           ax,xc
                     sub           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,x
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h

    ; Octante 7: (xc+y,yc-x)
                     xor           ax,ax
                     mov           ax,xc
                     add           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,x
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h
    ; Octante 8: (xc+x,yc-y)
                     xor           ax,ax
                     mov           ax,xc
                     add           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,y
                     mov           columna,ax
                     EscribirPixel fila, columna, 03h

    ; Actualización de variables
                     inc           x                                ; x +=1
                     cmp           p,0
                     jg            positivo

    ; Caso p <= 0: p += 2x+1
                     mov           ax, x
                     shl           ax,1
                     inc           ax
                     add           p, ax                            ; p += 2x+1
                     jmp           bucle_circulo
    
    positivo:        
    ; Caso p > 0: p += 2*(x-y)+1
                     mov           ax,x
                     sub           ax,y
                     mov           bl,2
                     shl           ax,1
                     inc           ax
                     add           p, ax                            ; p += 2(x-y)+1
                     dec           y                                ; y -=1
                     jmp           bucle_circulo
                    
    fin_circulo:     
                     jmp           puenteFin


    puenteRellenas2: 
                     jmp           Rellenas
                    
    ;------------------------------------------------------------------RELLENAS----------------------------------------------------------------------
    Rellenas:        
    ;modo grafico
                     mov           ax,0012h                         ;modo grafico
                     int           10h

    ;------------------------------------valores para cuadrado------------------------------------
                     mov           fila,85                          ;fila inicial
                     mov           columna,215                      ;columna inicial
                     mov           cx,125                           ;cuantas veces se ejecutara la linea
                     mov           ax,1                             ;contador de lineas repetidas ejecutadas
                     push          ax
                     jmp           short cuadradoR
    
    contador:        
                     add           fila,1                           ;avanzar un espacio abajo
                     mov           columna,215                      ;columna inicial
                     mov           cx,125                           ;cuantas veces se ejecutara la linea
                     push          ax
    cuadradoR:       
                     push          cx
                     mov           ax, 0c09h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizonal
                     pop           ax                               ;recuperar el contador
                     inc           ax                               ;contador de lineas repetidas ejecutadas incrementado
                     cmp           ax,125                           ;chequear si ya completo el cuadrado
                     jne           contador
                     jmp           short siga2


    puenteFin:       
                     jmp           fin

    siga2:           
    ;------------------------------------valores para rectangulo------------------------------------
                     mov           fila,55                          ;fila inicial
                     mov           columna,130                      ;columna inicial
                     mov           cx,165                           ;cuantas veces se ejecutara la linea
                     mov           ax,1
                     push          ax
                     jmp           short rectanguloR
        
    contador1:       
                     add           fila,1
                     mov           columna,130
                     mov           cx,165
                     push          ax
    rectanguloR:     
                     push          cx
                     mov           ax, 0c08h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizonal
                     pop           ax                               ;recuperar el contador
                     inc           ax
                     cmp           ax,50
                     jne           contador1

    ;------------------------------------valores para rombo------------------------------------
                     mov           fila,120                         ;fila inicial
                     mov           columna,177                      ;columna inicial
                     mov           cx,25                            ;cuantas veces se ejecutara la linea
                     mov           ax,1
                     push          ax
                     mov           acc,0                            ;Variable encargada de rellenar el rombo
                     jmp           short romboR
        
    contador2:       
                     mov           fila,120                         ;fila inicial
                     mov           columna,177                      ;columna inicial
                     mov           cx,25
                     mov           bx,acc
                     add           fila,bx
                     add           columna,bx
                     push          ax
    romboR:          
                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalAscendenteP         ;Dibuja un línea diagonal ascendente
                     pop           ax                               ;recuperar el contador
                     inc           ax
                     inc           acc
                     cmp           ax,25
                     jne           contador2

    ;Terminar de rellenar el rombo
                     mov           fila,121                         ;fila inicial
                     mov           columna,177                      ;columna inicial
                     mov           cx,25
                     mov           ax,1
                     push          ax
                     mov           acc,0
                     jmp           short romboR2

    contador3:       
                     mov           fila,121                         ;fila inicial
                     mov           columna,177                      ;columna inicial
                     mov           cx,25
                     mov           bx,acc
                     add           fila,bx
                     add           columna,bx
                     push          ax
    romboR2:         
                     push          cx
                     mov           ax, 0c06h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          RomboDiagonalAscendenteP         ;Dibuja un línea diagonal ascendente
                     pop           ax
                     inc           ax
                     inc           acc
                     cmp           ax,25
                     jne           contador3

        
    ;------------------------------------valores para triangulo------------------------------------
                     mov           fila,190                         ;fila inicial
                     mov           columna,100                      ;columna inicial
                     mov           cx,86                            ;longitud de la línea
                     mov           ax,1
                     push          ax
                     mov           acc,0
                     jmp           short trianguloR
        

    contador4:       
                     mov           fila,190                         ;fila inicial
                     mov           columna,100                      ;columna inicial
                     mov           cx,86                            ;cuantas veces se ejecutara la*base
                     mov           bx,acc
                     sub           fila,bx                          ;subir una fila
                     sub           fila,bx                          ;subir una fila
                     add           columna,bx                       ;avanzar una columna a la derecha
                     sub           cx,bx                            ;restar una repeticion
                     sub           cx,bx                            ;restar una repeticion
                     push          ax
                                                                                          
    trianguloR:      
                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizontal
                     pop           ax
                     inc           ax
                     add           acc,1
                     cmp           ax,44                            ;Altura del triángulo
                     jne           contador4


    ;Terminar de rellenar el triángulo
                     mov           fila,189                         ;fila inicial
                     mov           columna,100                      ;columna inicial
                     mov           cx,86                            ;longitud de la línea
                     mov           ax,1
                     push          ax
                     mov           acc,0
                     jmp           short trianguloR2
        
    contador5:       
                     mov           fila,189                         ;fila inicial
                     mov           columna,100                      ;columna inicial
                     mov           cx,86                            ;cuantas veces se ejecutara la *base
                     mov           bx,acc
                     sub           fila,bx                          ;subir una fila
                     sub           fila,bx                          ;subir una fila
                     add           columna,bx                       ;avanzar una columna a la derecha
                     sub           cx,bx                            ;restar una repeticion
                     sub           cx,bx                            ;restar una repeticion
                     push          ax
                                                                                        
    trianguloR2:     
                     push          cx
                     mov           ax, 0c05h                        ;Color y numero de interupcion
                     push          ax
                     push          columna
                     push          fila
                     call          LineaHorizontalP                 ;Dibuja un línea horizontal
                     pop           ax
                     inc           ax
                     add           acc,1
                     cmp           ax,44                            ;Altura del triángulo
                     jne           contador5

    ;------------------------------------valores para círculo relleno------------------------------------
                     mov           x, 0
                     mov           y, 50                            ; y =  radio
                     mov           p, -49                           ; p = 1 - radio
                     mov           xc, 170
                     mov           yc, 215
                     mov           columna,0
                     mov           fila,0
    bucle_circuloR:  
                     mov           ax,x
                     cmp           ax,y
                     jg            puente_circuloR
                     jmp           dibujar_lineas
    puente_circuloR: 
                     jmp           fin
    
    dibujar_lineas:  
    ; Línea 1: desde (xc+x, yc-y) hasta (xc+x, yc+y)
                     mov           ax,xc
                     add           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,y
                     mov           columna,ax
                     mov           ax,yc
                     add           ax,y
                     mov           columna_final,ax
                           
                     mov           ax, 0c03h                        ; Número de interrupción y color
                     push          ax
                     push          columna
                     push          fila
                     push          columna_final
                     call          LineaHorizontal2P                ; dibuja una línea entre ambas columnas

    ; Línea 2: desde (xc-x, yc-y) hasta (xc-x, yc+y)
                     mov           ax,xc
                     sub           ax,x
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,y
                     mov           columna,ax
                     mov           ax,yc
                     add           ax,y
                     mov           columna_final,ax
                           
                     mov           ax, 0c03h                        ; Número de interrupción y color
                     push          ax
                     push          columna
                     push          fila
                     push          columna_final
                     call          LineaHorizontal2P                ; dibuja una línea entre ambas columnas

    ; Línea 3: desde (xc+y, yc-x) hasta (xc+y, yc+x)
                     mov           ax,xc
                     add           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,x
                     mov           columna,ax
                     mov           ax,yc
                     add           ax,x
                     mov           columna_final,ax
                           
                     mov           ax, 0c03h                        ; Número de interrupción y color
                     push          ax
                     push          columna
                     push          fila
                     push          columna_final
                     call          LineaHorizontal2P                ; dibuja una línea entre ambas columnas

    ; Línea 4: desde (xc-y, yc-x) hasta (xc-y, yc+x)
                     mov           ax,xc
                     sub           ax,y
                     mov           fila,ax
                     mov           ax,yc
                     sub           ax,x
                     mov           columna,ax
                     mov           ax,yc
                     add           ax,x
                     mov           columna_final,ax
                           
                     mov           ax, 0c03h                        ; Número de interrupción y color
                     push          ax
                     push          columna
                     push          fila
                     push          columna_final
                     call          LineaHorizontal2P                ; dibuja una línea entre ambas columnas

    ; Actualización de variables
                     inc           x
                     cmp           p,0
                     jg            positivoR

    ; Caso p <= 0: p += 2x+1
                     mov           ax, x
                     shl           ax,1
                     inc           ax
                     add           p, ax
                     jmp           bucle_circuloR
    
    positivoR:       
                     mov           ax,x
                     sub           ax,y
                     shl           ax,1
                     inc           ax
                     add           p, ax
                     dec           y
                     jmp           bucle_circuloR
    fin:             
                     mov           ax,4c00h
                     int           21h

Codigo EndS
    End Inicio 