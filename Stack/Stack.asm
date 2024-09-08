; Program: Stack
; Date created: August 28, 2023
; Last updated: August 30, 2023
; Author: Tyseer Ammar Shahriar
; Compile using: nasm -fwin32 Stack.asm && gcc -m32 Stack.obj C:\Users\Lythops\Projects\Assembly\DSA\LinkedLists\LinkedLists.obj -o Stack.exe && Stack.exe

global _push@8
global _pop@4
global _peekS@4

extern _addEnd@8
extern _addStart@8
extern _add@12
extern _removeEnd@4
extern _removeStart@4
extern _remove@8
extern _printList@4
extern _getLength@4
extern _print@8

section .data
topPointer dd 0
empty db "Stack is empty", 10, 0
indicator db "n", 10, 0

section .bss
var resd 1

section .text
_push@8:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push ebx                                ; Save caller's registers
    push ecx

    mov ebx, [ebp + 12]                     ; Load stack topPointer into ebx
    mov ecx, [ebp + 8]                      ; Load data to be added into ecx

    push ebx
    push ecx
    call _addStart@8

    pop ecx                                 ; Restore caller's registers
    pop ebx

    pop ebp
    ret 8

_pop@4:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push ebx                                ; Save caller's registers

    mov ebx, [ebp + 8]                      ; Load stack topPointer into ebx

    push ebx
    call _removeStart@4

    pop ebx                                 ; Restore caller's registers

    pop ebp
    ret 4

_peekS@4:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push ebx                                ; Save caller's registers

    mov ebx, [ebp + 8]                      ; Load stack topPointer into ebx

    push ebx
    call _isEmpty@4                         ; Check if stack is empty

    cmp eax, 0                              ; If stack is not empty go to .notEmpty
    je .notEmpty

    .empty:                                 ; Print error message
    push 15
    push empty
    call _print@8
    jmp .exit

    .notEmpty:
    mov ebx, [ebx]                          ; Load top pointer into ebx
    mov eax, [ebx]                          ; Return value at the top of the stack

    .exit:
    pop ebx                                 ; Restore caller's registers

    pop ebp
    ret 4

_isEmpty@4:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push ebx                                ; Save caller's registers

    mov ebx, [ebp + 8]                      ; Load stack topPointer into ebx

    cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
    je .empty
    jmp .notEmpty

.empty:
    mov eax, 1                              ; Return 1 to indicate true
    jmp .exit

.notEmpty:
    mov eax, 0                              ; Return 0 to indicate false

.exit:
    pop ebx                                 ; Restore caller's registers

    pop ebp
    ret 4   
