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
extrn InicializarDS:Far, ClearScreenP:Far, WhereXYP:Far, GotoXYP:Far, PrintCharColorP:Far, PrintCharP:Far, PrintNum:Far, PrintString:Far, ReadKey:Far, WaitKeyP:Far, input_string:Far


Pila Segment
         db 64 Dup ('?')
Pila EndS

Datos Segment
    mensaje  db 10,13,"Desea que las figuras vayan vacias o rellenas? ",10,13,"Opcion:",10,13,"1) Vacias",10,13,"2) Rellenas",10,13,24h
    errorOp  db 10,13,"Error: Opcion invalida, intente de nuevo",  10,13,  "Presione cualquier tecla...",24h
    op       db ?

    fila     dw ?
    columna  dw ?
    ancho    dw ?
    alto     dw ?
    acc      dw ?

    x        dw ?
    y        dw ?
    xc       dw ?
    yc       dw ?
    p        dw ?

    
    ; Variables adicionales necesarias
    inicio_y dw ?
    fin_y    dw ?


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
                           mov           bh,0fh                          ; da color blanco a la pantalla
                           xor           cx,cx                           ; pone en 0 ch y cl
                           mov           dh,24                           ; fila inferior
                           mov           dl,79                           ; columna inferior
                           pushA
                           call          ClearScreenP                    ; limpiar pantalla
                           xor           dx,dx                           ; poner en 0 dh y dl para redireccionar cursor a 0,0
                           call          GotoXYP                         ; redireccionar cursor a 0,0

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
                           je            puenteRellenas
                           jmp           menu


    Vacias:                
    ;modo grafico
                           mov           ax,0012h                        ;modo grafico
                           int           10h

    ;------------------------------------valores para cuadrado------------------------------------
                           mov           fila,85                         ;fila inicial
                           mov           columna,215                     ;columna inicial
                           mov           cx,125                          ;cuantas veces se ejecutara la linea

    cuadrado:              
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color1                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          cuadrado

                           mov           cx,125                          ;cuantas veces se ejecutara la linea
                           mov           columna,215                     ;columna inicial
    cuadrado2:             
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color1                          ;llamar a pintar
                           add           fila,1                          ;avanzar un espacio abajo
                           pop           cx                              ;recuperar el contador
                           loop          cuadrado2

                           mov           cx,125                          ;cuantas veces se ejecutara la linea
    cuadrado3:             
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color1                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          cuadrado3

                           mov           cx,125                          ;cuantas veces se ejecutara la linea
    cuadrado4:             
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color1                          ;llamar a pintar
                           sub           fila,1                          ;avanzar un espacio arriba
                           pop           cx                              ;recuperar el contador
                           loop          cuadrado4
                           jmp           short siga

    puenteRellenas:        
                           jmp           puenteRellenas1

    siga:                  
    ;------------------------------------valores para rectangulo------------------------------------
                           mov           fila,55                         ;fila inicial
                           mov           columna,130                     ;columna inicial
                           mov           cx,165                          ;cuantas veces se ejecutara la linea

    rectangulo:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color2                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          rectangulo

                           mov           cx,50                           ;cuantas veces se ejecutara la linea
                           mov           columna,130                     ;columna inicial
    rectangulo2:           
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color2                          ;llamar a pintar
                           add           fila,1                          ;avanzar un espacio abajo
                           pop           cx                              ;recuperar el contador
                           loop          rectangulo2

                           mov           cx,165                          ;cuantas veces se ejecutara la linea
    rectangulo3:           
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color2                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          rectangulo3

                           mov           cx,50                           ;cuantas veces se ejecutara la linea
    rectangulo4:           
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color2                          ;llamar a pintar
                           sub           fila,1                          ;avanzar un espacio arriba
                           pop           cx                              ;recuperar el contador
                           loop          rectangulo4

    ;------------------------------------valores para rombo------------------------------------
                           mov           fila,120                        ;fila inicial
                           mov           columna,177                     ;columna inicial
                           mov           cx,25                           ;cuantas veces se ejecutara la linea

    rombo:                 
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           add           fila,1
                           pop           cx                              ;recuperar el contador
                           loop          rombo

                           mov           cx,25                           ;cuantas veces se ejecutara la linea
    rombo2:                
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           add           columna,1
                           add           fila,1                          ;avanzar un espacio abajo
                           pop           cx                              ;recuperar el contador
                           loop          rombo2

                           mov           cx,25                           ;cuantas veces se ejecutara la linea
    rombo3:                
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           sub           fila,1                          ;avanzar un espacio arriba
                           pop           cx                              ;recuperar el contador
                           loop          rombo3

                           mov           cx,25                           ;cuantas veces se ejecutara la linea
    rombo4:                
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           sub           fila,1                          ;avanzar un espacio arriba
                           sub           columna,1                       ;avanzar un espacio a la izquierda
                           pop           cx                              ;recuperar el contador
                           loop          rombo4
                           jmp           short siga1

    puenteRellenas1:       
                           jmp           puenteRellenas2

    siga1:                 
    ;------------------------------------valores para triangulo------------------------------------
                           mov           fila,105                        ;fila inicial
                           mov           columna,145                     ;columna inicial
                           mov           cx,42                           ;cuantas veces se ejecutara la linea

    triangulo:             
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           add           fila,2                          ;avanzar un espacio abajo
                           pop           cx                              ;recuperar el contador
                           loop          triangulo

                           mov           cx,83                           ;cuantas veces se ejecutara la linea
    triangulo2:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           add           columna,1
                           pop           cx                              ;recuperar el contador
                           loop          triangulo2

                           mov           cx,42                           ;cuantas veces se ejecutara la linea
    triangulo3:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           sub           fila,2                          ;avanzar un espacio arriba
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          triangulo3

    ;Lineas de relleno diagonales
                           mov           fila,106                        ;fila inicial
                           mov           columna,145                     ;columna inicial
                           mov           cx,42                           ;cuantas veces se ejecutara la linea

    triangulo4:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           add           fila,2                          ;avanzar un espacio abajo
                           pop           cx                              ;recuperar el contador
                           loop          triangulo4

                           mov           fila,106                        ;fila inicial
                           mov           columna,145                     ;columna inicial
                           mov           cx,42                           ;cuantas veces se ejecutara la linea

    triangulo5:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           add           fila,2                          ;avanzar un espacio arriba
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          triangulo5

    ;------------------------------------valores para círculo------------------------------------
                           mov           x, 0
                           mov           y, 50                           ; y =  radio
                           mov           p, -49                          ; p = 1 - radio
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

    ; Actaulización de variables
                           inc           x                               ; x +=1
                           cmp           p,0
                           jg            positivo

    ; Caso p <= 0: p += 2x+1
                           mov           ax, x
                           shl           ax,1
                           inc           ax
                           add           p, ax                           ; p += 2x+1
                           jmp           bucle_circulo
    
    positivo:              
    ; Caso p > 0: p += 2*(x-y)+1
                           mov           ax,x
                           sub           ax,y
                           mov           bl,2
                           shl           ax,1
                           inc           ax
                           add           p, ax                           ; p += 2(x-y)+1
                           dec           y                               ; y -=1
                           jmp           bucle_circulo
                    
    fin_circulo:           
                           jmp           puenteFin


    puenteRellenas2:       
                           jmp           Rellenas
                    
    ;------------------------------------------------------------------RELLENAS----------------------------------------------------------------------
    Rellenas:              
    ;modo grafico
                           mov           ax,0012h                        ;modo grafico
                           int           10h

    ;------------------------------------valores para cuadrado------------------------------------
                           mov           fila,85                         ;fila inicial
                           mov           columna,215                     ;columna inicial
                           mov           cx,125                          ;cuantas veces se ejecutara la linea
                           mov           ax,1                            ;contador de lineas repetidas ejecutadas
                           push          ax
                           jmp           short cuadradoR
    
    contador:              
                           add           fila,1                          ;avanzar un espacio abajo
                           mov           columna,215                     ;columna inicial
                           mov           cx,125                          ;cuantas veces se ejecutara la linea
                           push          ax
    cuadradoR:             
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color1                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          cuadradoR
                           pop           ax                              ;recuperar el contador
                           inc           ax                              ;contador de lineas repetidas ejecutadas incrementado
                           cmp           ax,125                          ;chequear si ya completo el cuadrado
                           jne           contador
                           jmp           short siga2


    puenteFin:             
                           jmp           fin

    siga2:                 
    ;------------------------------------valores para rectangulo------------------------------------
                           mov           fila,55                         ;fila inicial
                           mov           columna,130                     ;columna inicial
                           mov           cx,165                          ;cuantas veces se ejecutara la linea
                           mov           ax,1
                           push          ax
                           jmp           short rectanguloR
        
    contador1:             
                           add           fila,1
                           mov           columna,130
                           mov           cx,165
                           push          ax
    rectanguloR:           
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color2                          ;llamar a pintar
                           add           columna,1                       ;avanzar un espacio a la derecha
                           pop           cx                              ;recuperar el contador
                           loop          rectanguloR
                           pop           ax                              ;recuperar el contador
                           inc           ax
                           cmp           ax,50
                           jne           contador1

    ;------------------------------------valores para rombo------------------------------------
                           mov           fila,120                        ;fila inicial
                           mov           columna,177                     ;columna inicial
                           mov           cx,25                           ;cuantas veces se ejecutara la linea
                           mov           ax,1
                           push          ax
                           mov           acc,0
                           jmp           short romboR
        
    contador2:             
                           mov           fila,120                        ;fila inicial
                           mov           columna,177                     ;columna inicial
                           mov           cx,25
                           mov           bx,acc
                           add           fila,bx
                           add           columna,bx
                           push          ax
    romboR:                
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           add           fila,1
                           pop           cx                              ;recuperar el contador
                           loop          romboR
                           pop           ax                              ;recuperar el contador
                           inc           ax
                           add           acc,1
                           cmp           ax,25
                           jne           contador2

    ;rombo 2 (terminar relleno)
                           mov           fila,121                        ;fila inicial
                           mov           columna,177                     ;columna inicial
                           mov           cx,25
                           mov           ax,1
                           push          ax
                           mov           acc,0
                           jmp           short romboR2

    contador3:             
                           mov           fila,121                        ;fila inicial
                           mov           columna,177                     ;columna inicial
                           mov           cx,25
                           mov           bx,acc
                           add           fila,bx
                           add           columna,bx
                           push          ax
    romboR2:               
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color3                          ;llamar a pintar
                           sub           columna,1                       ;avanzar un espacio a la derecha
                           add           fila,1
                           pop           cx                              ;recuperar el contador
                           loop          romboR2
                           pop           ax
                           inc           ax
                           add           acc,1
                           cmp           ax,25
                           jne           contador3

        
    ;------------------------------------valores para triangulo------------------------------------
                           mov           fila,190                        ;fila inicial
                           mov           columna,100                     ;columna inicial
                           mov           cx,87                           ;cuantas veces se ejecutara la linea*base
                           mov           ax,1
                           push          ax
                           mov           acc,0
                           jmp           short trianguloR
        

    contador4:             
                           mov           fila,190                        ;fila inicial
                           mov           columna,100                     ;columna inicial
                           mov           cx,87                           ;cuantas veces se ejecutara la*base
                           mov           bx,acc
                           sub           fila,bx                         ;subir una fila
                           sub           fila,bx                         ;subir una fila
                           add           columna,bx                      ;avanzar una columna a la derecha
                           sub           cx,bx                           ;restar una repeticion
                           sub           cx,bx                           ;restar una repeticion
                           push          ax
                                                                                          
    trianguloR:            
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           add           columna,1
                           pop           cx                              ;recuperar el contador
                           loop          trianguloR
                           pop           ax
                           inc           ax
                           add           acc,1
                           cmp           ax,44                           ;*altura
                           jne           contador4

                           mov           fila,133                        ;fila inicial
                           mov           columna,145                     ;columna inicial
                           mov           cx,columna
                           mov           dx,fila
                           call          Color4

    ;triangulo2 (terminar relleno)
                           mov           fila,189                        ;fila inicial
                           mov           columna,100                     ;columna inicial
                           mov           cx,87                           ;*base
                           mov           ax,1
                           push          ax
                           mov           acc,0
                           jmp           short trianguloR2
        
    contador5:             
                           mov           fila,189                        ;fila inicial
                           mov           columna,100                     ;columna inicial
                           mov           cx,87                           ;cuantas veces se ejecutara la *base
                           mov           bx,acc
                           sub           fila,bx                         ;subir una fila
                           sub           fila,bx                         ;subir una fila
                           add           columna,bx                      ;avanzar una columna a la derecha
                           sub           cx,bx                           ;restar una repeticion
                           sub           cx,bx                           ;restar una repeticion
                           push          ax
                                                                                        
    trianguloR2:           
                           push          cx                              ;almacenar el contador
                           mov           cx,columna                      ;columna
                           mov           dx,fila                         ;fila
                           call          Color4                          ;llamar a pintar
                           add           columna,1
                           pop           cx                              ;recuperar el contador
                           loop          trianguloR2
                           pop           ax
                           inc           ax
                           add           acc,1
                           cmp           ax,44                           ;*altura
                           jne           contador5

    ;------------------------------------valores para círculo relleno------------------------------------
                           mov           x, 0
                           mov           y, 50                           ; y =  radio
                           mov           p, -49                          ; p = 1 - radio
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
                           jmp           fin_circulo
    
    dibujar_lineas:        
    ; Línea 1: desde (xc+x, yc-y) hasta (xc+x, yc+y)
                           mov           ax,xc
                           add           ax,x
                           mov           fila,ax
                           mov           ax,yc
                           sub           ax,y
                           mov           inicio_y,ax
                           mov           ax,yc
                           add           ax,y
                           mov           fin_y,ax
                           call          dibujar_linea_vertical

    ; Línea 2: desde (xc-x, yc-y) hasta (xc-x, yc+y)
                           mov           ax,xc
                           sub           ax,x
                           mov           fila,ax
                           mov           ax,yc
                           sub           ax,y
                           mov           inicio_y,ax
                           mov           ax,yc
                           add           ax,y
                           mov           fin_y,ax
                           call          dibujar_linea_vertical

    ; Línea 3: desde (xc+y, yc-x) hasta (xc+y, yc+x)
                           mov           ax,xc
                           add           ax,y
                           mov           fila,ax
                           mov           ax,yc
                           sub           ax,x
                           mov           inicio_y,ax
                           mov           ax,yc
                           add           ax,x
                           mov           fin_y,ax
                           call          dibujar_linea_vertical

    ; Línea 4: desde (xc-y, yc-x) hasta (xc-y, yc+x)
                           mov           ax,xc
                           sub           ax,y
                           mov           fila,ax
                           mov           ax,yc
                           sub           ax,x
                           mov           inicio_y,ax
                           mov           ax,yc
                           add           ax,x
                           mov           fin_y,ax
                           call          dibujar_linea_vertical

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

    ; Subrutina para dibujar línea VERTICAL
    dibujar_linea_vertical:
                           mov           cx, inicio_y
    dibujar_pixel_v:       
                           mov           columna, cx
                           EscribirPixel fila, columna, 03h
                           inc           cx
                           cmp           cx, fin_y
                           jle           dibujar_pixel_v
                           ret

                    
    fin_circuloR:          
                           jmp           fin

    Color1:                
                           mov           ah,0ch
                           mov           al,09
                           int           10h
                           ret

    Color2:                
                           mov           ah,0ch
                           mov           al,08
                           int           10h
                           ret
            
    Color3:                
                           mov           ah,0ch
                           mov           al,06
                           int           10h
                           ret

    Color4:                
                           mov           ah,0ch
                           mov           al,05
                           int           10h
                           ret

    fin:                   
                           mov           ax,4c00h
                           int           21h

Codigo EndS
    End Inicio 