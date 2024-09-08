; Program: Arrays and Algorithms
; Date created: August 10, 2023
; Last updated: August 10, 2023
; Author: Tyseer Ammar Shahriar

global _main
extern _GetStdHandle@4
extern _WriteConsoleA@20

section .data
    array dd 101, 102, 103, 104, 105, 106, 107, 111, 113
    msgFound db "Found", 10, 0
    msgNotFound db "NotFound", 10, 0
    indicator db "n", 10, 0

section .bss
    return resd 1                       ; Variable to hold the return value of the binary search function (So it can be printed)

section .text
_main:
    push array
    push 9
    push 105
    call _binarySearch@12

    add eax, 100

    mov [return], eax

    push 4
    push return
    call _print@8

    ret                                 ; Exit process

_binarySearch@12:                       ; Function argument format: (Array pointer (dword), Array size (dword), target (dword))
    push ebp                            ; Set up stack frame
    mov ebp, esp

    push ebx                            ; Save callers registers that will be used (except eax as that will contain return value)
    push ecx
    push edx
    push esi
    push edi

    mov ebx, [ebp + 8]                  ; Store target in ebx
    mov edi, [ebp + 12]                 ; Store array size in edi (edi will be used to store high index in search space)
    mov edx, [ebp + 16]                 ; Store array pointer in edx

    mov esi, 0                          ; esi will be used to store low index in search space
    dec edi                             ; Arrays start at 0

searchLoop:
    push edx                            ; Save pointer to array
    push esi                            ; Save the low index value

    add esi, edi                        ; Add high index and low index together
    mov eax, esi                        ; Move sum to eax to be divided
    mov edx, 0                          ; Clear edx for division
    mov ecx, 2

    div ecx                             ; Divide eax by 2 leaving mid index in eax

    pop esi                             ; Restore the low index value
    pop edx                             ; Restore the array pointer

    mov ecx, [edx + eax*4]              ; Move value stored in mid index to ecx
    mov [return], ecx                   ; Move value of mid element to first address of return

    push 4                              ; Print mid element
    push return
    call _print@8

    cmp ebx, [edx + eax*4]              ; Check to see if the mid value is the target value, or if it is less or greater ERROR AREA!!!!!!!!
    je equal                            ; If mid value matches target then return with target index in eax
    jg greater                          ; If target value is greater than mid value
    jl less                             ; If target value is less than mid value

greater:
    cmp esi, edi                        ; Compare low index and high index
    je notFound                         ; If low and high indexes are equal and target does not equal mid index then the element is not in the array

    inc eax
    mov esi, eax                        ; Get rid of lower half of the search space by updating low index to the mid index + 1
    jmp searchLoop
less:
    cmp esi, edi                        ; Compare low index and high index
    je notFound                         ; If low and high indexes are equal and target does not equal mid index then the element is not in the array

    dec eax
    mov edi, eax                        ; Get rid of upper half of the search space by updating high index to the mid index - 1
    jmp searchLoop
equal:
    push 7
    push msgFound
    call _print@8

    pop edi                             ; Restore caller's registers
    pop esi
    pop edx
    pop ecx
    pop ebx

    pop ebp
    ret 12
notFound:
    mov eax, -1                         ; Indicate that the element was not found

    push 10
    push msgNotFound
    call _print@8

    pop edi                             ; Restore caller's registers
    pop esi
    pop edx
    pop ecx
    pop ebx

    pop ebp
    ret 12

_print@8:                               ; Function argument format: (string size, string pointer)
    push ebp                            ; Set up stack frame
    mov ebp, esp

    push eax                            ; Save callers registers that will be used
    push ebx
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
    pop ebx
    pop eax

    pop ebp
    ret 8