# Bootloader For i386
our cross compiler:
i686-elf-gcc
Runs on QEMU

bootloader stage 1 and 2, created by following the os development series at brokenthorn.com

Features-
  Protected Mode
  GDT tables
  A VGA driver
  Enabling A20 for 4GB of addressing
  FAT12 formatting
  Jumps to the kernel file
  

