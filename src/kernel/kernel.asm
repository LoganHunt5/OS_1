; 32 BITS
ORG 0x100000
BITS 32

jmp Stage3

%include "/home/logan/Projects/OS_1/src/bootloader/include/vgaASM.inc"
thirtytwo_success: DB 'Monkey covering eyes emoji',  0

Stage3:
; set registers to code segment of gdt
MOV ax, 0x10

MOV ds, ax
MOV ss, ax
MOV es, ax
MOV esp, 0x90000

CALL ClearScreen 
MOV ebx, thirtytwo_success
CALL Puts32

Stop:
  CLI 
  HLT


