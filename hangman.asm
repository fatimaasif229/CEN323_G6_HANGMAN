.model small
.stack 100h

.data

;Word Bank

word0 db "EmanPagal$"
word1 db "Cristiano$"
word2 db "Bobzy$"
word3 db "Kroos$"
word4 db "Monitors$"
word5 db "Huraira$"
word6 db "Resume$"
word7 db "Griffin$"

wordPtrs dw offset word0, offset word1, offset word2, offset word3,
         dw offset word4, offset word5, offset word6, offset word7

;Game State Variables

currentWord  db 20 dup("$")
guessedWord  db 20 dup(" ")
wrongGuesses db 20 dup(0)

wordLen      db 0
wrongCount   db 0
guessedCount db 0
gameOver     db 0

;LCG Seed

randSeed dw 0

.code
main proc

    mov ax, @data
    mov ds, ax

    mov ah, 00h
    int 1ah

    xor dx, cx
    mov randSeed, dx

    call Pick_Word

    mov ah, 4ch
    int 21h

main endp


Pick_Word proc

    mov ax, randSeed
    mov bx, 25173
    mul bx
    add ax, 13849
    mov randSeed, ax

    xor dx, dx
    mov bx, 8
    div bx

    mov bx, dx
    shl bx, 1

    mov si, wordPtrs[bx]

    lea di, currentWord
    lea bx, guessedWord

    mov cx, 0

Copy_Loop:

    mov al, [si]
    cmp al, "$"

    je Copy_Done

    mov [di], al
    mov byte ptr [bx], "_"

    inc si
    inc di
    inc bx
    inc cx

    jmp Copy_Loop


Copy_Done:

    mov [di], al
    mov byte ptr [bx], "$"

    mov wordLen, cl
    mov wrongCount, 0
    mov guessedCount, 0
    mov gameOver, 0

    lea di, wrongGuesses
    mov cx, 20

Clear_Wrong:

    mov byte ptr [di], 0

    inc di
    loop Clear_Wrong

    ret

Pick_Word endp

end main