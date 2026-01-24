BITS 16
ORG 0x500

; loaded at linear address 0x10000
JMP Stage2 

%include "/home/logan/Projects/OS_1/src/bootloader/include/stdio16.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/GDT.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/A20.inc"

; Data section
os_boot_message: DB 'FOUND STAGE 2', 0x0D, 0x0A, 0
new_line: DB '', 0x0A, 0
; thirtytwo_success: DB 'Monkey covering eyes emoji', 0x0A, 0
thirtytwo_success: DB 'Monkey covering eyes emoji',  0

Stage2:
  CLI
  XOR     ax, ax
  MOV     ds, ax
  MOV     es, ax
  MOV     fs, ax
  MOV     gs, ax

  ; stack starts at ffff and goes to 9000 
  MOV     ax, 0x9000
  MOV     ss, ax
  MOV     sp, 0xFFFF
  STI

  MOV     si,os_boot_message
  CALL    ASMPrint 

  CALL    loadGDT

  CALL    activateA20
  ; go into pmode
  CLI
  MOV     eax, cr0
  OR      eax, 1
  MOV     cr0, eax

  ; mov cs to gdt code segment
  ; puts 0x8 in cs start of data segment, and ip to stage3
  JMP 0x08:Stage3



; 32 BITS
BITS 32

%include "/home/logan/Projects/OS_1/src/bootloader/include/vgaASM.inc"

Stage3:
; set registers to code segment of gdt
MOV ax, 0x10

MOV ds, ax
MOV es, ax
MOV fs, ax
MOV gs, ax
MOV ss, ax
MOV esp, 0x90000

CALL ClearScreen 


MOV ebx, thirtytwo_success
CALL Puts32

Stop:
  CLI 
  HLT




