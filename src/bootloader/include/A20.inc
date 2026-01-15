bits 16

wait_input:
  in    al, 0x64     ;read status register
  test  al,2         ; test bit 2 (Input buffer status)
  jnz   wait_input   ; jump if it's not empty
  ret

wait_output:
  in    al, 0x64     ; read stauts reg
  test  al,1         ; test output buffer status
  jz    wait_output  ; wait for buffer to fill
  ret

activateA20:
  cli
  pusha

  ; disable the keyboard
  call wait_input
  mov   al,0xAD
  out   0x64,al
  call  wait_input

  ; send read to output port
  mov   al,0xD0
  out   0x64,al
  call  wait_output

  ; read input buffer and store on stack.
  in    al,0x60
  push  eax
  call  wait_input

  ; send write output port command
  mov  al,0xD1
  out  0x64,al
  call wait_input

  ; pop output port data from stack and set bit 1 to enable a20
  pop  eax
  or   al,2
  out  0x60,al

  ; enable keyboard
  call wait_input
  mov  al,0xAE
  out  0x64,al
  call wait_input

  popa
  sti
  ret
