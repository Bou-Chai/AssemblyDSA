; Program: I/O Utilities Library
; Date created: September 1, 2023
; Last updated: September 1, 2023
; Author: Tyseer Ammar Shahriar

global _print@8
global _getInput@8
global _clearBuffer@8

extern _GetStdHandle@4
extern _WriteConsoleA@20
extern _ReadConsoleA@20

section .data

section .bss
charsRead resd 1

section .text
_print@8:                               ; Function argument format: (string size, string pointer)
    push ebp                            ; Set up stack frame
    mov ebp, esp

    push eax                            ; Save callers registers that will be used
    push ebx
    push ecx
    push edx

    push dword -11                      ; Specify stdout
    call _GetStdHandle@4                ; Load handle of stdout in eax

    mov edx, [ebp + 8]                  ; Get message pointer from stack
    mov ebx, [ebp + 12]                 ; Get buffer size argument from stack

    push dword 0                        ; lpReserved must be void
    push dword 0                        ; Optional argument     
    push ebx                            ; Size of buffer
    push edx                            ; Message to display
    push eax                            ; Handle to stdout
    call _WriteConsoleA@20              ; Print user prompt

    pop edx                             ; Restore caller's registers
    pop ecx
    pop ebx
    pop eax

    pop ebp
    ret 8

_getInput@8:                            ; Function argument format: (Number of characters to read, buffer pointer)
    push ebp                            ; Set up stack frame
    mov ebp, esp

    push eax                            ; Save callers registers that will be used
    push ebx
    push ecx
    push edx                            

    push dword -10                      ; Specify stdin
    call _GetStdHandle@4                ; Load handle of stdin in eax

    mov edx, [ebp + 8]                  ; Get buffer pointer from stack
    mov ebx, [ebp + 12]                 ; Get number of characters to read from stack

    push dword 0                        ; Optional
    push charsRead                      ; Number of characters actually read
    push ebx                            ; Number of characters to read
    push edx                            ; Input buffer
    push eax                            ; Handle to stdin
    call _ReadConsoleA@20               ; Read input

    pop edx                             ; Restore caller's registers
    pop ecx
    pop ebx
    pop eax

    pop ebp
    ret 8

_clearBuffer@8:                         ; Function argument format: (buffer pointer, buffer size in bytes)
    push ebp                            ; Set up stack frame
    mov ebp, esp

    push eax                            ; Save callers registers that will be used
    push ecx                            

    mov ecx, [ebp + 8]                  ; Get buffer size
    mov eax, [ebp + 12]                 ; Get buffer pointer

    dec ecx                             ; Buffer starts at 0 offset

    clearLoop:
    mov [eax + ecx], byte 0             ; Clear the byte offset by ecx to 0
    sub ecx, 1                          ; Decrement ecx
    jnz clearLoop

    pop ecx                             ; Restore caller's registers
    pop eax

    pop ebp
    ret 8
