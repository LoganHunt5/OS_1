%define ROOT_OFFSET 0x2e00
%define FAT_SEG 0x2c0
%define ROOT_SEG 0x2e0


;load root directory table
LoadRoot:
  pusha
  push es
  xor cx, cx
  xor dx, dx
  mov ax, 32        ; 32 byte directory entry
  mul WORD [bpbRootEntries]
  div WORD [bpbBytesPerSector] ;sectors used by directory
  xchg ax, cx

  ;find start of root directory and put in ax
  mov al, byte [bpbNumberOfFATs]
  mul word [bpbSectorsPerFAT]
  add ax, word [bpbReservedSectors]
  mov word [datasector], ax         ;start in ax
  add word [datasector], cx         ;end in datasector


  ; read root dir
  push word ROOT_SEG
  pop es
  xor bx, bx
  call ReadSectors
  pop es
  popa
  ret


; root dir in es:di 
LoadFAT:
  pusha
  push es
  ; find fat size
  xor ax, ax
  mov al, byte [bpbNumberOfFATs]
  mul word [bpbSectorsPerFAT]
  mov cx, ax

  mov ax, word[bpbReservedSectors]

  ; read fat into mem
  push word FAT_SEG
  pop es
  xor bx, bx
  call ReadSectors
  pop es
  popa
  ret

;ds:si file name
; ax return, file index number in directory table. -1 if error
FindFile:
    push cx
    push dx
    push bx
    mov bx, si    ;copy filename for later
    
    ;look for filename
    mov cx, word [bpbRootEntries]
    mov di, ROOT_OFFSET
    cld             ; clear direction flag just in case

    .LOOP:
      push cx
      mov cx, 11
      mov si, bx
      push di
      rep cmpsb
      pop di
      je .Found
      pop cx
      add di, 32    ; go to next entry
      loop .LOOP

    .NotFound:
      pop bx
      pop dx
      pop cx
      mov ax, -1
      ret

    .Found:
      pop ax ; ax gets entry of file (pushed as cx)
      pop bx
      pop dx
      pop cx
      ret


; es:si file to load
; bx:bp buffer to load file to
; ret ax -1 on error, 0 on success
; ret cx Number of sectors loaded
LoadFile:
  xor ecx, ecx
  push ecx            ; # of sectors loaded
  .FIND_FILE:
    push bx
    push bp           ; store buffer to write to
    call FindFile
    cmp ax, -1
    jne .LOAD_IMAGE_PRE
    pop bp
    pop bx
    pop ecx
    mov ax, -1
    ret

  .LOAD_IMAGE_PRE:
    sub edi, ROOT_OFFSET
    sub eax, ROOT_OFFSET
    
    ; get starting cluster
    push word ROOT_SEG
    pop es
    mov dx, word [es:di + 0x001A] ; get to starting cluster
    mov word [cluster], dx
    pop bx                        ;bx
    pop es                        ; buffer to write to (bp)
    push bx                       ; need buffer offset on top
    push es

    call LoadFAT

  .LOAD_IMAGE:
    mov ax, word [cluster]
    pop es
    pop bx
    call ClusterLBA
    xor cx, cx
    add cl, byte[bpbSectorsPerCluster]

  ;compute next cluster
    mov ax, word[cluster]
    mov cx, ax
    mov dx, ax 
    shr dx, 1
    add cx, dx      ; 3/2 of cluster to find byte

    mov bx, 0       ;location of fat
    add bx, cx
    mov dx, word [es:bx]  ;load 2 bytes
    test ax, 1
    jnz .ODD_CLUSTER

  .EVEN_CLUSTER:
    and dx, 0x0FFF
    jmp .DONE

  .ODD_CLUSTER:
    shr dx, 4

  .DONE:
    mov word[cluster], dx     ;new cluster
    cmp dx, 0x0FF0            ;check for end of file
    jb  .LOAD_IMAGE
  .LoadFileDone:
    pop es
    pop bx
    pop ecx
    xor ax, ax                ;return 0
    ret

