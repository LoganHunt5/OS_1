%define IA32_SYSENTER_CS 0x174
%define IA32_SYSENTER_ESP 0x175
%define IA32_SYSENTER_EIP 0x176

mov eax, 0x8      ;kernel code descriptor
mov edx, 0
mov ecx, IA32_SYSENTER_CS
wrmsr

mov eax, esp
mov edx, 0
mov ecx, IA32_SYSENTER_ESP
wrmsr

mov eax, SysenterEntry
mov edx, 0
mov ecx, IA32_SYSENTER_EIP
wrmsr

SysenterEntry:
