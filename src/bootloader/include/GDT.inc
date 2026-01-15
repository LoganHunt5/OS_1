bits 16 

; loadGDT()
loadGDT:
    cli
    pusha
    lgdt [gdtPointer]
    sti
    popa
    ret

gdtStart:
    ; null descriptor
    dd 0
    dd 0

    ; code descriptor offset is 0x08

    dw 0xFFFF             ; limit low
    dw 0                  ; base low
    db 0                  ; base middle
    db 0b10011010         ; access bits
    db 0b11001111         ; granularity
    db 0                  ; base high

    ; data descriptor, same except for a 1 in access
    ; tells cpu its a data descrpitor
    dw 0xFFFF             ; limit low
    dw 0                  ; base low
    db 0                  ; base middle
    db 0b10010010         ; access bits
    db 0b11001111         ; granularity
    db 0                  ; base high

gdtEnd:
gdtPointer:
      dw  gdtEnd - gdtStart - 1
      dd  gdtStart
    ; needs to follow this exact format for lgdt
