; MACROS DEL PROYECTO CRUD

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
