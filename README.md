# Coal-Project-Hangman
.model small
.stack 100h

.data

word1 db "EmanPagal$"
word2 db "Cristiano$"
word3 db "Bobzy$"
word4 db "Kroos$"
word5 db "Monitors$"
word6 db "Huraira$"
word7 db "Resume$"
word8 db "Griffins$"

wordptr dw offset word1, offset word2, offset word3, offset word4,
        dw offset word5, offset word6, offset word7, offset word8



currentWord db 20 dup<"$">
guessedWord db 20 dup<" ">
wrongGuesses db 20 dup<0>
wordLen      db 0
wrongCount   db 0
guessesCount db 0
gameOver     db 0

msgTitle   db '========= HANGMAN GAME =========' , 13,10, '$'
msgGuess   db 13, 10, 'Enter a letter: $'
msgWord    db 13, 10, 'Wrong! Try again.', 13, 10, '$'
msgCorrect db 13, 10, 'Correct!', 13,10,'$'
msgAlready db 13, 10, 'Already guessed that letter!', 13, 10, '$'
msgWin     db 13, 10, '*** YOU WIN! Congratulations! ***', 13, 10 '$'
msgLose    db 13, 10, '*** YOU LOSE! Better luck next time! ***', 13, 10 '$'
msgWord    db 13, 10, 'The word was: $'
msgWrongs  db 13, 10, 'Wrong letters: $'
msgsTries  db 13, 10, 'Tries left: $'
msgNewline db 13, 10, '$'
msgEnter   db 13, 10, 'Press any key to exit---', '$'

randSeed dw 0

hang0 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang1 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10, ; head appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang2 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |   |  ', 13, 10,   ; body appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang3 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|  ', 13, 10,   ; left arm appears
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang4 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10, ; both arms appear
DB '  |      ', 13, 10,
DB '  |      ', 13, 10,
DB '=========$'

hang5 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10,
DB '  |  /   ', 13, 10, ; left leg appears 
DB '  |      ', 13, 10,
DB '=========$'

hang6 DB '  +---+  ', 13, 10,
DB '  |   |  ', 13, 10,
DB '  |   O  ', 13, 10,
DB '  |  /|\ ', 13, 10,
DB '  |  / \ ', 13, 10, ; both legs - game over stage
DB '  |      ', 13, 10,
DB '=========$'

hangPtrs dw offset hang0, offset hang1, offset hang2, offset hang3, 
         dw offset hang4, offset hang5, offset hang6
.code
Main Proc
       mov ax, @data
       mov ds, ax
       mov ah,00h
       int 1ah
       xor dx, cx
       mov randSeed, dx
       call Pick_Word
       
Game_Loop:
      call Clear_screen
      lea dx,msgTilte 
      mov ah,09h
      int 21h
      call Print_Hangman
      lea dx, msgTries
      mov ah, 09h
      int 21h
      mov al, 6
      sub al, wrongCount
      add al, 30h
      mov dl, al
      mov ah, 02h
      int 21h
      lea dx, msgWrongs
      mov ah, 09h
      int 21h
      all Print_Word_Letters
      lea dx, msgNewLline
      mov ah, 09h
      int 21h
      call Print_Gueesed_Word
      cmp gameOver, 1
      je PLAYER_WON
      cmp gameOver, 2
      je PLAYER-LOST
      lea dx, msgGuess
      mov ah, 09h
      int 21h
      mov ah,01h
      int21h
      mov bl,al
      cmp bl,61h
      jl Skip_Upper
      cmp bl,7ah
      jg Skip_Upper
      sub bl, 20h
Skip_Upper
      
       
       











































