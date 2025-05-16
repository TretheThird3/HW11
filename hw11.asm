SECTION .data
    inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A ; Input buffer with hex values
    newline db 0xA 

section .bss
    outputBuf resb 80 ; Output buffer for ASCII representation (80 bytes)

section .text
    global _start

_start:
    ;addresses of input and output are stored as well as interator
    mov ebx, inputBuf  
    xor esi, esi
    xor edi, edi
    ;mov esi, outputBuf 
    mov ecx, 8         

loop_start:
    movzx eax, byte [ebx] ; Move byte from inputBuf to eax, zero-extend to 32 bits

    ; Convert the high byte to ASCII
    mov dl, al         ; Copy the lower byte of eax (which contains the input byte) to dl
    shr dl, 4          ; Shift right by 4 bits to get the high byte
    and dl, 0x0F       ; Mask the upper byte (keep only the lower 4 bits)
    add dl, '0'        ; Add '0' to convert to ASCII (0-9)
    cmp dl, '9'        ; Compare with '9'
    jle store_high     ; If less than or equal to '9', it's a digit
    add dl, 7          ; If greater than '9', add 7 to get 'A'-'F'

store_high:
    mov [inputBuf+esi], dl      ; Store the ASCII character in the output buffer
    inc esi            ; Increment the output buffer pointer


    ; Convert the low byte to ASCII
    mov dl, al         ; Copy the lower byte of eax to dl
    and dl, 0x0F       ; Mask the upper byte (keep only the lower 4 bits)
    add dl, '0'        ; Add '0' to convert to ASCII (0-9)
    cmp dl, '9'        ; Compare with '9'
    jle store_low      ; If less than or equal to '9', it's a digit
    add dl, 7          ; If greater than '9', add 7 to get 'A'-'F'

store_low:
    mov [inputBuf+esi], dl      ; Store the ASCII character in the output buffer
    inc esi
    inc ebx            ; Moves to the next byte in inputBuf
    dec ecx            ; Decrements the loop counter
    jnz loop_start     ; If the loop counter is not zero, continues loop

; Print the output buffer (ASCII representation of hex values)
mov eax, 4         ; System call number for SYS_WRITE
mov edi, 1         ; File descriptor for stdout (standard output)
mov esi, outputBuf ; Address of the output buffer
mov edx, 16       ; Length of the output buffer to print (16 bytes)
mov eax, 4      ; calls SYS_WRITE which is represented by kernel opcode 4
int 80h         ; call interupt

mov eax, 4         ; System call number for SYS_WRITE
mov edi, 1         ; File descriptor for stdout
mov esi, newline   ; Address of the newline character
mov edx, 1         ; Length of the newline character
mov eax, 4      ; calls SYS_WRITE which is represented by kernel opcode 4
int 80h         ; call interupt

; Exit the program
mov ebx, 0      ; return 0 status on exit meaning 'No Errors'
mov eax, 1      ; calls SYS_EXIT(represented by kernel opcode 1) to avoid a segmentation fault
int 80h         ; call interupt
