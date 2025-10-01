ORG 0x7C00
BITS 16

main:
  MOV ax,0
  MOV ds,ax
  MOV es,ax
  MOV ss,ax

  MOV sp, 0x7C00
  HLT

halt:
  JMP halt

TIMES 510-($-$$) DB 0
DW 0AA55h

print:
  PUSH si
  PUSH ax
  PUSH bx
