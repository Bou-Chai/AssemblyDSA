; Program: Linked Lists and Algorithms
; Date created: August 21, 2023
; Last updated: September 1, 2023
; Author: Tyseer Ammar Shahriar
; Assemble using: nasm -fwin32 LinkedLists.asm

global _addEnd@8
global _addStart@8
global _add@12
global _removeEnd@4
global _removeStart@4
global _remove@8
global _getLength@4
global _printList@4

extern _HeapAlloc@12
extern _HeapFree@12
extern _GetProcessHeap@0
extern _GetStdHandle@4
extern _WriteConsoleA@20
extern _print@8

section .data
indicator db "n", 10, 0
error db "err", 10, 0
;head db "abcd", 0, 0, 0, 0
;headPointer dd head
headPointer dd 0
outOfBounds db "Requested index is out of bounds", 10, 0
empty db "List is empty", 10, 0

section .bss

section .text
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;                                                                                                                                    ;
;                                                 Functions for adding to list                                                       ;
;                                                                                                                                    ;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;

_addEnd@8:                              ; Function argument format: (list headPointer, data)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx

mov ebx, [ebp + 12]                     ; Store headPointer of list in ebx
mov ecx, [ebp + 8]                      ; Store data to be added in ecx

push ecx                                ; Save ecx because it changes for some reason

call _GetProcessHeap@0                  ; Get handle to the process heap

push 8                                  ; Number of bytes to be allocated (One double word for the data and one double word for the address of the next node)
push 8                                  ; Initialize allocated bytes to zero
push eax                                ; Handle to heap
call _HeapAlloc@12

pop ecx                                 ; Restore ecx

cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
je .empty
mov ebx, [ebx]                          ; Load head pointer into ebx
jmp .loop

.empty:
mov [ebx], eax                          ; Assign new node as head
mov [eax], ecx                          ; Move desired data to node
jmp .exit

.loop:                                  ; Iterate to the end of the list
cmp dword[ebx + 4], 0                   ; Check to see if current node's link field is null
je .endFound                            ; If the end of the list has been reached go to endFound
mov ebx, [ebx + 4]                      ; Move onto next node by loading address of next node into ebx
jmp .loop                               ; Default

.endFound:
mov [ebx + 4], eax                      ; Set the last node's link field to the address of the newly allocated memory
mov [eax], ecx                          ; Set the data of the new node

.exit:
pop ecx                                 ; Restore registers
pop ebx
pop eax

pop ebp
ret 8

_addStart@8:                            ; Function argument format: (list headPointer, data)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx
push edx

mov ebx, [ebp + 12]                     ; Store headPointer of list in ebx
mov ecx, [ebp + 8]                      ; Store data to be added in ecx

push ecx                                ; Save ecx because it changes for some reason

call _GetProcessHeap@0                  ; Get handle to the process heap

push 8                                  ; Number of bytes to be allocated (One double word for the data and one double word for the address of the next node)
push 8                                  ; Initialize allocated bytes to zero
push eax                                ; Handle to heap
call _HeapAlloc@12

pop ecx                                 ; Restore ecx

push ebx
mov ebx, [ebx]                          ; Load head pointer into ebx
mov [eax + 4], ebx                      ; Link the new node to the start of the list
pop ebx
mov [ebx], eax                          ; Assign new node as head of list
mov [eax], ecx                          ; Store data in new node

pop edx                                 ; Restore registers
pop ecx                                 
pop ebx
pop eax

pop ebp
ret 8

_add@12:                                ; Function argument format: (list head pointer, index, data)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx
push edx
push esi

mov ebx, [ebp + 16]                     ; Store headPointer of list in ebx
mov edx, [ebp + 12]                     ; Desired index for new node
mov ecx, [ebp + 8]                      ; Store data to be added in ecx

push ecx                                ; Save ecx because it changes for some reason
push edx

call _GetProcessHeap@0                  ; Get handle to the process heap

push 8                                  ; Number of bytes to be allocated (One double word for the data and one double word for the address of the next node)
push 8                                  ; Initialize allocated bytes to zero
push eax                                ; Handle to heap
call _HeapAlloc@12

pop edx
pop ecx                                 ; Restore ecx

cmp edx, 0                              ; If desired index is 0
je .caseZero
jl .outOfBounds
mov ebx, [ebx]                          ; Load head pointer into ebx
jmp .loop

.caseZero:                              ; In case desired index is 0
push ebx                                ; Save pointer to head pointer
mov ebx, [ebx]                          ; Load head pointer into ebx
mov [eax + 4], ebx                      ; Set new node's pointer
pop ebx                                 ; Restore pointer to head pointer
mov [ebx], eax                          ; New node is the head pointer
mov [eax], ecx                          ; Set data of the new node
jmp .exit

cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
je .outOfBounds

.loop:                                  ; In case desired index is not 0 (Load the node with the index that comes before the desired index into ebx)
cmp edx, 1                              ; 
je .indexFound
sub edx, 1                              ; Decrement with each pass
mov ebx, [ebx + 4]                      ; Move onto next node by loading address of next node into ebx
cmp ebx, 0                              ; Check to see if last node
je .outOfBounds                         ; List end found before desired index
jg .loop
; jl error

.indexFound:
mov esi, [ebx + 4]                      ; Load address of the node that comes after the new node into esi
mov [eax + 4], esi                      ; Set pointer of new node
mov [ebx + 4], eax                      ; Set previous node pointer to new node
mov [eax], ecx                          ; Store data in new node
jmp .exit

.outOfBounds:
push 34
push outOfBounds
call _print@8
jmp .exit

.exit:
pop esi                                 ; Restore registers
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 12

;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;                                                                                                                                    ;
;                                                 Functions for removing from list                                                   ;
;                                                                                                                                    ;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;

_removeEnd@4:                           ; Function argument format: (list head pointer)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx
push edx
push esi

mov ebx, [ebp + 8]                      ; Store headPointer of list in ebx

cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
je .empty

push ebx                                ; Save pointer to head pointer
mov ebx, [ebx]                          ; Load head pointer into ebx

cmp dword[ebx + 4], 0                   ; If list head is only element 
pop ebx                                 ; Load pointer to head pointer into ebx
je .oneElement
mov ebx, [ebx]                          ; Load head pointer into ebx
jmp .loop

.oneElement:                     
mov dword[ebx], 0                       ; Make head pointer null

call _GetProcessHeap@0                  ; Get handle to the process heap

mov ebx, [ebx]                          ; Load head pointer into ebx

push ebx                                ; Pointer to the last node
push 0                                  ; Use serialized access?
push eax                                ; Handle to heap
call _HeapFree@12
jmp .exit

.loop:                                  ; Iterate to the end of the list
mov esi, [ebx + 4]                      ; Store the pointer to the node ahead of the current node in eax
cmp dword[esi + 4], 0                   ; Check to see if next node's link field is null
je .endFound                            ; If the second last element has been reached go to endFound
mov ebx, [ebx + 4]                      ; Move onto next node by loading address of next node into ebx
jmp .loop                               ; Default

.endFound:
mov dword[ebx + 4], 0                   ; Set pointer of second last node to null
call _GetProcessHeap@0                  ; Get handle to the process heap

push esi                                ; Pointer to the last node
push 0                                  ; Use serialized access?
push eax                                ; Handle to heap
call _HeapFree@12
jmp .exit

.empty:                                 ; Print error message
push 15
push empty
call _print@8

.exit:
pop esi                                 ; Restore registers
pop edx
pop ecx
pop ebx
pop eax

pop ebp
ret 4

_removeStart@4:                         ; ; Function argument format: (list head pointer)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx
push edx
push esi

mov ebx, [ebp + 8]                      ; Store head pointer in ebx

cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
je .empty

push ebx                                ; Save pointer to head pointer
mov ebx, [ebx]                          ; Load head pointer into ebx
mov esi, [ebx + 4]                      ; Load address of 2nd node into esi
pop ebx                                 ; Restore pointer to head pointer in ebx

call _GetProcessHeap@0                  ; Load process heap into eax

push dword[ebx]                         ; Address of allocated memory to be freed
push 0                                  ; Use serialzed access?
push eax                                ; Handle to process heap
call _HeapFree@12

mov [ebx], esi                          ; Make 2nd node the first node
jmp .exit

.empty:                                 ; Print error message
push 15
push empty
call _print@8

.exit:
pop esi                                 ; Restore registers
pop edx
pop ecx                                 
pop ebx
pop eax

pop ebp
ret 4

_remove@8:                              ; Function argument format: (list head pointer, index)
push ebp
mov ebp, esp

push eax                                ; Save registers used
push ebx
push ecx
push edx
push esi

mov ebx, [ebp + 12]                     ; Store head pointer in ebx
mov edx, [ebp + 8]                      ; Index of node to be deleted

cmp dword[ebx], 0                       ; Check to see if head pointer is null (is the list empty?)
je .empty

cmp edx, 0                              ; If desired index is 0
je .caseZero
jl .outOfBounds
mov ebx, [ebx]                          ; Load head pointer into ebx
jmp .loop

.caseZero:                              ; In case desired index is 0
push ebx                                ; Save pointer to head pointer
mov ebx, [ebx]                          ; Load head pointer into ebx
mov esi, [ebx + 4]                      ; Load address of 2nd node into esi
pop ebx                                 ; Restore pointer to head pointer in ebx

call _GetProcessHeap@0                  ; Load process heap into eax

push dword[ebx]                         ; Address of allocated memory to be freed
push 0                                  ; Use serialzed access?
push eax                                ; Handle to process heap
call _HeapFree@12

mov [ebx], esi                          ; Make 2nd node the first node
jmp .exit

.loop:                                  ; In case desired index is not 0 (Load the node with the index that comes before the desired index into ebx)
cmp edx, 1                              ; 
je .indexFound
sub edx, 1                              ; Decrement with each pass
mov ebx, [ebx + 4]                      ; Move onto next node by loading address of next node into ebx
cmp dword[ebx + 4], 0                   ; Check to see if last node
je .outOfBounds                         ; List end found before desired index
jg .loop
; jl error

.indexFound:
mov esi, [ebx + 4]
mov esi, [esi + 4]                      ; Load address of node that comes after node to be deleted in esi

call _GetProcessHeap@0                  ; Load handle to process heap in eax
push dword[ebx + 4]                     ; Address of allocated memory to be freed
push 0                                  ; Use serialzed access?
push eax                                ; Handle to process heap
call _HeapFree@12

mov [ebx + 4], esi                      ; Exclude node to be deleted from list
jmp .exit

.outOfBounds:
push 34
push outOfBounds
call _print@8
jmp .exit

.empty:                                 ; Print error message
push 15
push empty
call _print@8

.exit:
pop esi                                 ; Restore registers
pop edx
pop ecx                                 
pop ebx
pop eax

pop ebp
ret 8

;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;                                                                                                                                    ;
;                                                                Others                                                              ;
;                                                                                                                                    ;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;


_getLength@4:                           ; Function argument format: (list headPointer, data)
push ebp
mov ebp, esp

push ebx                                ; Save caller's registers
push ecx

mov ebx, [ebp + 8]                      ; Load headpointer in ebx

mov ebx, [ebx]                          ; Load head pointer into ebx

cmp ebx, 0                              ; Check to see if head pointer is null (is the list empty?)
je .empty

mov ecx, 0                              ; Initialize count to 0

.loop:                                  ; Iterate to the end of the list
inc ecx
cmp dword[ebx + 4], 0                   ; Check to see if current node's link field is null
je .endFound                            ; If the end of the list has been reached go to endFound
mov ebx, [ebx + 4]                      ; Move onto next node by loading address of next node into ebx
jmp .loop                               ; Default

.empty:                                 ; Print error message
push 15
push empty
call _print@8

.endFound:
mov eax, ecx                            ; Return list length in eax

pop ecx                                 ; Restore caller's registers
pop ebx

pop ebp
ret 8

_printList@4:                           ; Function argument format: (list headPointer)
push ebp
mov ebp, esp

push eax                                ; Save caller's registers

mov eax, [ebp + 8]                      ; Get list pointer/headPointer

mov eax, [eax]                          ; Load head pointer into ebx

printLoop:
push 4                                  ; Print current node's data
push eax                                
call _print@8

cmp dword[eax + 4], 0                   ; Check to see if end of list has been reached (is the link field null?)
je .endFound                            ; Escape print loop if end of list has been reached

mov eax, [eax + 4]                      ; Move onto next node by loading address of next node into eax
jmp printLoop                           ; Default

.endFound:
pop eax                                 ; Restore caller's registers

pop ebp
ret 4
