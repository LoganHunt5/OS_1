%define VIDMEM 0xB8000
%define  VIDMEM 0xB8000   ; video memory
%define  COLS 80   ; width and height of screen
%define  LINES 25
%define  CHAR_ATTRIB 11010001b   ; character attribute (idk on idk background)
_CurX db 0
_CurY db 0

ClearScreen:
  pusha
  xor eax, eax
  mov ebx, COLS
  mov eax, LINES
  mul ebx
  mov ecx, eax
  mov edi, VIDMEM
  xor eax, eax
.clearScreenLoop:
  mov [edi+eax], byte ' '
  mov [edi+1+eax], byte CHAR_ATTRIB
  inc eax
  inc eax
  loop .clearScreenLoop
.endClearScreen:
  popa
  ret


; char in bl 
Putch32:
  pusha
  xor eax,eax
  mov edi, VIDMEM
  cmp bl, 0x0A
  je .Putch32Row ;check for new line

  mov ecx, COLS*2
  mov al, byte [_CurY]
  mul ecx
  push eax            ; push y index

  mov al, byte [_CurX]
  mov cl, 2
  mul cl               ;get x index in eax
  pop ecx
  add eax, ecx
  mov [edi+eax], byte bl
  mov [edi+eax+1], byte CHAR_ATTRIB 
  inc byte [_CurX]
  cmp [_CurX], byte COLS
  jne .Putch32Done
  .Putch32Row:
    mov byte [_CurX], 0
    inc byte [_CurY]
  .Putch32Done:
    popa
    ret

;string in ebx 
Puts32:
  pusha
  push ebx     ; so can put char in bl
  pop edi
  .Puts32Loop:
    mov bl, byte [edi]
    cmp bl, 0
    je .Puts32Done
    call Putch32
    inc edi
    jmp .Puts32Loop
  .Puts32Done:
    mov bh, byte [_CurY]
    mov bl, byte [_CurX]
    call updateCursor
    popa
    ret


; bh is y
; bl is x
updateCursor:
  pusha
  ;get current position
  ;y
  xor eax, eax
  mov ecx, COLS
  mov al, bh
  mul ecx
  ;x
  add al, bl
  ; pos in ebx
  mov ebx, eax


  ; set low byte in vga
  ; send to index register, 0x0f is low byte for cursor
  mov al, 0x0F
  mov dx, 0x03D4
  out dx, al

  ; send low to data register
  mov al, bl
  mov dx, 0x03D5
  out dx, al
  
  ;set high byte
  xor eax, eax
  mov al, 0x0E 
  mov dx, 0x03D4
  out dx, al

  mov al, bh
  mov dx, 0x03D5
  out dx, al

  popa 
  ret
