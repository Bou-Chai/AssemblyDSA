; Program: Bracket Checker
; Date created: September 1, 2023
; Last updated: September 2, 2023
; Author: Tyseer Ammar Shahriar
; Compile using: nasm -fwin32 Brackets.asm && gcc -m32 Brackets.obj C:\Users\Lythops\Projects\Assembly\DSA\Stack\Stack.obj C:\Users\Lythops\Projects\Assembly\DSA\LinkedLists\LinkedLists.obj C:\Users\Lythops\Projects\Assembly\Utils\IO.obj -o Brackets.exe && Brackets.exe

global _main

extern _push@8
extern _pop@4
extern _peek@4
extern _print@8
extern _getInput@8
extern _clearBuffer@8

section .data
prompt db "Input:", 10, 0
indicator db "n", 10, 0
topPointer dd 0
balanced db "Balanced", 10, 0
unbalanced db "Unbalanced", 10, 0

section .bss
input resb 1024
current resd 1

section .text
_main:
push input
push 1024
call _clearBuffer@8

push 8
push prompt
call _print@8

push 1024
push input
call _getInput@8

mov ebx, input
mov ecx, 0                                  ; Clear ecx

readLoop:
mov cl, [ebx]                               ; Load current character of input string into cl

mov [current], cl

push 1
push current
call _print@8

cmp cl, 0                                   ; Check for end of string
je endOfString

cmp cl, 40                                  ; Check if chracter read is an opening bracket
je .store
cmp cl, 91
je .store
cmp cl, 123
je .store

cmp cl, 41                                  ; Check if chracter read is a closing bracket                    
je .removeCheck
cmp cl, 93
je .removeCheck
cmp cl, 125
je .removeCheck

add ebx, 1
jmp readLoop

.removeCheck:                               ; Check to see if closing bracket matches opening bracket in stack
cmp dword[topPointer], 0                    ; If the current character is a closing bracket and the stack is empty then bracket expression is unbalanced
je notEmpty

push topPointer
call _peek@4                                ; Load value at the top of the stack into eax

dec cl                                      ; Decrement value of closing bracket by one (value of round closing and opening brackets differ by 1)
cmp eax, ecx
je .remove
dec cl                                      ; Decrement value of closing bracket again (value of other closing and opening brackets differ by 2)
cmp eax, ecx
je .remove

add ebx, 1
jmp readLoop

.remove:
push topPointer
call _pop@4

add ebx, 1
jmp readLoop

.store:
push topPointer
push ecx
call _push@8

add ebx, 1
jmp readLoop

endOfString:                               ; End of the string containing the brackets
cmp dword[topPointer], 0
je empty
jmp notEmpty

empty:
push 10
push balanced
call _print@8
jmp exit

notEmpty:
push 12
push unbalanced
call _print@8

exit:
ret
