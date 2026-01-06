
; InstallGDT()

InstallGDT:
  cli
  pusha
  lgdt [toc]
  sti
  popa
  ret

gdt_data:
dd 0    ; NULL descriptor
dd 0


; Offset 0x8 bytes from start of GDT: Descriptor code therfore is 8
; gdt code:       ; code descriptor
dw 0FFFFh       ; limit low
dw 0            ; base low
db 0            ; base middle
db 10011010b    ; access
db 11001111b    ; granularity
db 0            ; base high


; Offset 16 bytes (0x10) from start of GDT. Descriptor code therfore is 0x10.
; gdt data:
dw 0FFFFh       ; limit low
dw 0            ; base low
db 0            ; base middle
db 10010010b    ; access
db 11001111b    ; granularity
db 0            ; base high


;...Other descriptors begin at offset 0x18. Remember that each descriptor is 8 bytes in size?
; Add other descriptors for Ring 3 applications, stack, whatever here...


end_of_gdt:
toc: 
	dw end_of_gdt - gdt_data - 1  ; limit (Size of GDT)
	dd gdt_data                   ; base of GDT
