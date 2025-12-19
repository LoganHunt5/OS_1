ORG 0x0
BITS 16

; loaded at linear address 0x10000


main:
  CLI
  push cs
  pop ds  ; make cs = ds
  JMP print
  cli
  HLT

print:
  MOV si,os_boot_message
  XOR bh,bh

print_loop:
  LODSB
  OR al,al
  JZ done_print

  MOV ah,0x0E
  INT 0x10

  JMP print_loop

done_print:
  RET

; Data section

os_boot_message: DB 'FOUND STAGE 2', 0x0D, 0x0A, 0
