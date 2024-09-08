; Program: Binary Tree
; Date created: September 3, 2023
; Last updated: September 3, 2023
; Author: Tyseer Ammar Shahriar
; Compile using: nasm -fwin32 BinTree.asm && gcc -m32 BinTree.obj C:\Users\Lythops\Projects\Assembly\DSA\Que\Que.obj C:\Users\Lythops\Projects\Assembly\DSA\Stack\Stack.obj C:\Users\Lythops\Projects\Assembly\DSA\LinkedLists\LinkedLists.obj C:\Users\Lythops\Projects\Assembly\Utils\IO.obj -o BinTree.exe && BinTree.exe

global _main

extern _print@8
extern _getInput@8
extern _HeapAlloc@12
extern _HeapFree@12
extern _GetProcessHeap@0
extern _GetStdHandle@4
extern _enqueue@12
extern _dequeue@4
extern _peekQ@4
extern _push@8
extern _pop@4
extern _peekS@4

section .data
rootPointer dd 0
frontPointer dd 0
rearPointer dd 0
topPointer dd 0
indicator db "n", 10, 0

section .bss
printData resd 1

section .text
_main:
mov ebx, rootPointer

push ebx
push 97
call _insertNode@8

mov esi, [ebx]                              ; Load pointer to tree root in esi
push esi                                    
push 98
call _insertNode@8                          ; Insert node as left child (root.left)

lea esi, [esi + 8]                          
push esi
push 99
call _insertNode@8                          ; Insert node as right child (root.right)

mov esi, [ebx]                              ; Load pointer to tree root in esi
mov esi, [esi]                              ; Load address of first left child node into esi
push esi                                    
push 100
call _insertNode@8                          ; Insert node as root.left.left

mov esi, [esi]                              ; Load root.left.left into esi
push esi
push 104
call _insertNode@8                          ; Insert node as root.left.left.left

lea esi, [esi + 8]
push esi
push 105
call _insertNode@8                          ; Insert node as root.left.left.right

mov esi, [ebx]
mov esi, [esi]                              ; Load root.left into esi
lea esi, [esi + 8]
push esi                                    
push 101
call _insertNode@8                          ; Insert node as root.left.right

mov esi, [esi]                              ; Load root.left.right into esi
push esi                                    
push 106
call _insertNode@8                          ; Insert node as root.left.right.left

lea esi, [esi + 8]                          ; Load right child field of root.left.right into esi
push esi                                    
push 107
call _insertNode@8                          ; Insert node as root.left.right.right

mov esi, [ebx]                              ; Load pointer to tree root in esi
mov esi, [esi + 8]                          ; Load address of root.right into esi
push esi
push 102
call _insertNode@8                          ; Insert node as root.right.left 

lea esi, [esi + 8]
push esi
push 103
call _insertNode@8                          ; Insert node as root.right.right

push dword[rootPointer]
call _printDFS@4

ret

_insertNode@8:
    push ebp
    mov ebp, esp

    push eax                                ; Save registers used
    push ebx
    push ecx
    push edx

    mov ebx, [ebp + 12]                     ; Store pointer to parent node left or right in ebx
    mov ecx, [ebp + 8]                      ; Store data to be added in ecx

    push ecx                                ; Save ecx because it changes for some reason

    call _GetProcessHeap@0                  ; Get handle to the process heap

    push 12                                 ; Number of bytes to be allocated (4 bytes for left child, 4 bytes for data, 4 bytes for right child)
    push 8                                  ; Initialize allocated bytes to zero
    push eax                                ; Handle to heap
    call _HeapAlloc@12

    pop ecx                                 ; Restore ecx

    mov [eax + 4], ecx                      ; Store desired data in new node
    mov [ebx], eax                          ; Assign new node as child node

    pop edx                                 ; Restore registers
    pop ecx                                 
    pop ebx
    pop eax

    pop ebp
    ret 8

_printBFS@4:
    push ebp
    mov ebp, esp

    push eax                                ; Save registers used
    push ebx
    push ecx
    push edx

    mov ebx, [ebp + 8]                      ; Root pointer (not pointer of root pointer)

    .loop:
        cmp ebx, 0
        je .exit

        mov ecx, [ebx + 4]                      ; Load current node's data into ecx
        mov [printData], ecx                    ; Prepare data to be printed
        push 4
        push printData
        call _print@8

        cmp dword[ebx], 0                       ; Check if current node has a left child
        jne .queueLeft
        jmp .checkRight                         ; Make sure current node is checked for for right child

        .queueLeft:                             ; Add pointer to left to queue
            push frontPointer
            push rearPointer
            push dword[ebx]
            call _enqueue@12

        .checkRight:
            cmp dword[ebx + 8], 0               ; Check if current node has a right child
            jne .queueRight
            jmp .checkEnd                       ; Don't try to queue if right child field is null

        .queueRight:                            ; Add pointer of right child to queue
            push frontPointer
            push rearPointer
            push dword[ebx + 8]
            call _enqueue@12
        .checkEnd:

        push frontPointer
        call _peekQ@4                            ; Store next node in path in eax
        push frontPointer
        call _dequeue@4                         ; Dequeue node pointer

        mov ebx, eax                            ; Update current node
        jmp .loop

    .exit:
        pop edx                                 ; Restore registers
        pop ecx                                 
        pop ebx
        pop eax

        pop ebp
        ret 4

_printDFS@4:
    push ebp
    mov ebp, esp

    push eax                                ; Save registers used
    push ebx
    push ecx
    push edx

    mov ebx, [ebp + 8]                      ; Root pointer (not pointer of root pointer)

    .loop:
        cmp ebx, 0
        je .exit

        mov ecx, [ebx + 4]                      ; Load current node's data into ecx
        mov [printData], ecx                    ; Prepare data to be printed
        push 4
        push printData
        call _print@8

        cmp dword[ebx], 0                       ; Check if current node has a left child
        jne .pushLeft
        jmp .checkRight                         ; Make sure current node is checked for for right child

        .pushLeft:                             ; Add pointer to left to queue
            push topPointer
            push dword[ebx]
            call _push@8

        .checkRight:
            cmp dword[ebx + 8], 0               ; Check if current node has a right child
            jne .pushRight
            jmp .checkEnd                       ; Don't try to queue if right child field is null

        .pushRight:                            ; Add pointer of right child to queue
            push topPointer
            push dword[ebx + 8]
            call _push@8
        .checkEnd:

        push topPointer
        call _peekS@4                            ; Store next node in path in eax
        push topPointer
        call _pop@4                         ; Dequeue node pointer

        mov ebx, eax                            ; Update current node
        jmp .loop

    .exit:
        pop edx                                 ; Restore registers
        pop ecx                                 
        pop ebx
        pop eax

        pop ebp
        ret 4
