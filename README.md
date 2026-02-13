# Bootloader For i386
bootloader stage 1 and 2, created by following the os development series at brokenthorn.com </br></br>
our cross compiler:</br>
i686-elf-gcc</br>
Runs on QEMU


## Features
<ul>
<li>Protected Mode</li>
<li>GDT tables</li>
<li>A VGA driver</li>
<li>Enabling A20 for 4GB of addressing</li>
<li>FAT12 formatting</li>
<li>Jumps to the kernel file</li>
</ul>
  

