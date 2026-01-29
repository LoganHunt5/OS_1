BITS 16
ORG 0x500

; loaded at linear address 0x10000
JMP Stage2 

%include "/home/logan/Projects/OS_1/src/bootloader/include/stdio16.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/GDT.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/A20.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/Floppy16.inc"
%include "/home/logan/Projects/OS_1/src/bootloader/include/Fat12.inc"

%define IMAGE_PMODE_BASE 0x100000
%define IMAGE_RMODE_BASE 0x3000

ImageName  DB "KERNEL     "
ImageSize DB 0
os_boot_message: DB 'FOUND STAGE 2', 0x0D, 0x0A, 0
msgFailure: DB 'COULD NOT FIND KERNEL', 0x0D, 0x0A, 0
new_line: DB '', 0x0A, 0
; thirtytwo_success: DB 'Monkey covering eyes emoji', 0x0A, 0

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

  CALL    LoadRoot


  ; load da kernel
  MOV     ebx, 0      ;buffer to load to
  MOV     bp, IMAGE_RMODE_BASE        ;bc we have to temp load it to less than 1MB
  MOV     esi, ImageName
  CALL    LoadFile
  MOV     dword[ImageSize], ecx
  CMP     ax, 0                   ;test for success
  JE      EnterStage3 
  MOV     si, msgFailure
  CALL    ASMPrint 
  CLI
  HLT

  EnterStage3:
  ; go into pmode
  CLI
  MOV     eax, cr0
  OR      eax, 1
  MOV     cr0, eax

  ; mov cs to gdt code segment
  ; puts 0x8 in cs start of data segment, and ip to stage3
  JMP 0x08:Stage3

bits 32
Stage3:
  MOV     ax, 0x10    ; data selector
  MOV     ds, ax
  MOV     ss, ax
  MOV     es, ax
  MOV     esp,0x90000
  
  ; move kernel to 1mb
CopyImage:
  mov eax, dword[ImageSize]
  movzx ebx, word[bpbBytesPerSector]
  mul ebx
  mov ebx, 4
  div ebx
  cld
  mov esi, IMAGE_RMODE_BASE
  mov edi, IMAGE_PMODE_BASE
  mov ecx, eax
  rep movsd

  jmp 0x8:IMAGE_PMODE_BASE

  cli
  hlt




