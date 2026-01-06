ORG 0x0
BITS 16

; loaded at linear address 0x10000
JMP main

%include "/home/logan/Projects/OS_1/src/bootloader/include/stdio16.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/GDT.inc"

main:
  CLI
  PUSH cs
  POP ds  ; make cs = ds
  MOV si,os_boot_message
  CALL ASMPrint 
  CLI 
  HLT

; Data section

os_boot_message: DB 'FOUND STAGE 2', 0x0D, 0x0A, 0
