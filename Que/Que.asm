; Program: Que
; Date created: August 30, 2023
; Last updated: September 1, 2023
; Author: Tyseer Ammar Shahriar
; Compile using: nasm -fwin32 Que.asm && gcc -m32 Que.obj C:\Users\Lythops\Projects\Assembly\DSA\LinkedLists\LinkedLists.obj -o Que.exe && Que.exe

global _main
global _enqueue@12
global _dequeue@4
global _peekQ@4

extern _HeapAlloc@12
extern _HeapFree@12
extern _GetProcessHeap@0
extern _print@8

section .data
frontPointer dd 0
rearPointer dd 0
empty db "Queue is empty", 10, 0
indicator db "n", 10, 0

section .bss
return resd 1

section .text
_enqueue@12:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push eax                                ; Save caller's registers
    push ebx
    push ecx
    push edx
    push esi

    mov esi, [ebp + 16]                     ; Load queue frontPointer into esi
    mov ebx, [ebp + 12]                     ; Load queue rearPointer into ebx
    mov ecx, [ebp + 8]                      ; Load data to be added into ecx

    push ecx                                ; Save ecx because eax, ecx, and edx are not safe with stdcall
    call _GetProcessHeap@0                  ; Get handle to the process heap 
    push 8                                  ; Number of bytes to be allocated (One double word for the data and one double word for the address of the next node)
    push 8                                  ; Initialize allocated bytes to zero
    push eax                                ; Handle to heap
    call _HeapAlloc@12
    pop ecx                                 ; Restore ecx
    mov [eax], ecx                          ; Store desired data in new node

    cmp dword[esi], 0                       ; Check to see if frontPointer is null (is the queue empty?)
    je .empty
    jmp .notEmpty

    .empty:
        mov [ebx], eax                          ; Update rear pointer to point to new node
        mov [esi], eax                          ; Update front pointer to point to new node
        jmp .exit

    .notEmpty:
        push ebx                                ; Save pointer to rear pointer
        mov ebx, [ebx]                          ; Load rear ponter into ebx
        mov [ebx + 4], eax                      ; Link last node in the queue to the new node
        pop ebx                                 ; Restore pointer to rear pointer
        mov [ebx], eax                          ; Update rear pointer to point to new node

    .exit:
        pop esi                                 ; Restore caller's registers
        pop edx
        pop ecx
        pop ebx
        pop eax

        pop ebp
        ret 12

_dequeue@4:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push eax                                ; Save caller's registers
    push ecx
    push esi
    push edx

    mov esi, [ebp + 8]                     ; Load queue frontPointer into eax

    cmp dword[esi], 0                       ; Check to see if frontPointer is null (is the queue empty?)
    je .empty
    jmp .notEmpty

    .empty:
        push 16
        push empty
        call _print@8
        jmp .exit

    .notEmpty:
        mov edx, [esi]                          ; Load front pointer into edx

        push edx                                ; Save front pointer
        mov edx, [edx + 4]
        mov [esi], edx                          ; Update front pointer to point to next node (or null if only one element is in the list)
        pop edx                                 ; Restore front pointer

        call _GetProcessHeap@0                  ; Get handle to the process heap
        push edx                                ; Pointer to the first node
        push 0                                  ; Use serialized access?
        push eax                                ; Handle to heap
        call _HeapFree@12

    .exit:
        pop edx                                 ; Restore caller's registers
        pop esi
        pop ecx
        pop eax

        pop ebp
        ret 4

_peekQ@4:
    push ebp                                ; Set up stack frame
    mov ebp, esp

    push esi

    mov esi, [ebp + 8]                     ; Load queue frontPointer into esi

    cmp dword[esi], 0                       ; Check to see if frontPointer is null (is the queue empty?)
    je .empty
    jmp .notEmpty

    .empty:
        push 16
        push empty
        call _print@8

        mov eax, 0                              ; Return 0 if queue is empty

        jmp .exit

    .notEmpty:
        mov esi, [esi]                          ; Load front pointer into esi
        mov eax, [esi]                          ; Return the value in the front node in eax

    .exit:
        pop esi

        pop ebp
        ret 4
