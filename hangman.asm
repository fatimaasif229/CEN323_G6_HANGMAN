.model small
.stack 100h

.data


     word0 db "EMANPAGAL$"
     word1 db "CRISTIANO$" 
     word2 db "BOBZY$"
     word3 db "KROOS$"
     word4 db "MONITORS$"
     word5 db "HURAIRA$"
     word6 db "RESUME$"
     word7 db "GRIFFINS$"


wordPtrs dw offset word0, offset word1, offset word2, offset word3,
         dw  offset word4, offset word5, offset word6, offset word7



currentWord  db 20 dup("$")
guessedWord  db 20 dup("_")
wrongGuesses db 20 dup(0)

wordLen      db 0
wrongCount   db 0
guessedCount db 0
gameOver     db 0



msgTitle   db "========= HANGMAN GAME =========", 13, 10, "$"
msgGuess   db 13, 10, "Enter a letter: $"
msgWrong   db 13, 10, "Wrong! Try again.", 13, 10, "$"
msgCorrect db 13, 10, "Correct!" ,13, 10, "$"
msgAlready db 13, 10, "Already guessed that letter!", 13, 10, "$"
msgWin     db 13, 10, "*** YOU WIN! Congratulations!***", 13, 10, "$"
msgLose    db 13, 10, "*** YOU LOSE! Better luck next time! ***", 13, 10,"$"
msgWord    db 13, 10, "The word was: $" 
msgWrongs  db 13, 10, " Wrong letters: $"
msgTries   db 13, 10, "Tries left: $"
msgNewline db 13, 10, "$"
msgEnter   db 13, 10, "Press any key to exit...", "$"


randSeed dw 0



 
hang0 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "=========$"


hang1 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "=========$"


hang2 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "=========$"


hang3 db '  +---+  ', 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |  /|  ", 13, 10,
           db "  |      ", 13, 10,
           db "  |      ", 13, 10,
           db "=========$"


hang4 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |  /|",5ch," ", 13, 10,
           db "  |     ", 13, 10,
           db "  |     ", 13, 10,
           db "=========$"


hang5 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |  /|",5ch," ", 13, 10,
           db "  |  /  ", 13, 10,
           db "  |     ", 13, 10,
           db "=========$"


hang6 db "  +---+  ", 13, 10,
           db "  |   |  ", 13, 10,
           db "  |   O  ", 13, 10,
           db "  |  /|",5ch," ", 13, 10,
           db "  |  / ",5ch," ", 13, 10,
           db "  |      ", 13, 10,
           db "=========$"


hangPtrs dw offset hang0, offset hang1, offset hang2, offset hang3, 
         dw offset hang4, offset hang5, offset hang6


.code
main proc

       mov ax, @data
       mov ds, ax

       mov ah, 00h
       int 1ah
       xor dx, cx
       mov randSeed, dx

       call Pick_Word


Game_Loop:
       
         call Clear_Screen

         lea dx,msgTitle
         mov ah, 09h
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
         call Print_wrong_letters


         lea dx, msgNewline
         mov ah, 09h
         int 21h
         call Print_guessed_word 


         cmp gameOver, 1
         je Player_Won
 
         cmp gameOver, 2
         je Player_Lost

         lea dx, msgGuess
         mov ah, 09h
         int 21h

         mov ah, 01h
         int 21h
         mov bl, al

         cmp bl, 61h
         jl Skip_Upper
         cmp bl, 7ah
         jg Skip_Upper
         sub bl, 20h


 
Skip_Upper:

       cmp bl, 41h
       jl Game_Loop
       cmp bl, 5ah
       jg Game_Loop


      call Process_Guess
      jmp Game_Loop


         
Player_won:

         lea dx, msgWin
         mov ah, 09h
         int 21h

         jmp Exit_Game



Player_Lost:

         lea dx, msgLose
         mov ah, 09h
         int 21h

         lea dx, msgWord
         mov ah, 09h
         int 21h
         call Print_current_word


       
Exit_Game:

         lea dx, msgEnter
         mov ah, 09h
         int 21h

         mov ah, 01h
         int 21h
         

         mov ah, 4ch
         int 21h

main endp



Pick_word proc

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
 
       lea di, currentword
       lea bx, guessedword

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
       mov wrongCount,   0
       mov guessedCount, 0
       mov gameOver,     0

      lea di, wrongGuesses
      mov cx, 20



Clear_wrong:

      mov byte ptr [di], 0

      inc di
      loop Clear_wrong

      ret


Pick_word endp


Process_Guess proc
   
     push ax
     push cx
     push si
     push di

     lea si, wrongGuesses
     mov cx, 20


Check_wrong_Dup:

    mov al,[si]
    cmp al, 0

    je Not_In_Wrong
    cmp al, bl
    je Already_Guessed
    inc si
    Loop Check_wrong_Dup


Not_In_Wrong:
    lea si, guessedword


Check_correct_Dup:
   
     mov al,[si]
     cmp al, "$"

     je Not_In_Correct
     cmp al, bl
     je Already_Guessed
     inc si
    jmp Check_correct_Dup


Not_In_Correct:

    lea si, currentWord
    lea di, guessedWord
    mov cx,0


Search_Loop:

    mov al,[si]
    cmp al,"$"
    je Search_Done
    cmp al,bl
    jne No_Match
    mov [di],bl
    inc cx
    inc guessedCount


No_Match:

   inc si
   inc di
   jmp Search_Loop


Search_Done: 
  
    cmp cx,0
    je wrong_Guess

    lea dx,msgCorrect
    mov ah, 09h
    int 21h
 
    mov al, guessedCount
    cmp al, wordLen
    jge Player_Wins
    jmp Guess_Done


wrong_Guess:

    lea di, wrongGuesses
    mov cx, 20


Find_Slot:

    mov al, [di]
    cmp al, 0
    je Add_wrong
    inc di
    Loop Find_Slot
    jmp Guess_Done


Add_wrong:

    mov [di],Bl
    inc wrongCount
 
    lea dx,msgWrong
    mov ah, 09h
    int 21h

    cmp wrongCount,6
    jge Player_Loses
    jmp Guess_Done

                      
Already_Guessed:

    lea dx, msgAlready
    mov ah, 09h
    int 21h
    jmp Guess_Done


Player_Wins:

   mov gameOver,1
   jmp Guess_Done


Player_Loses:

   mov gameOver,2



Guess_Done:
    
    pop di
    pop si
    pop cx
    pop ax

   ret

   Process_Guess endp




Print_Hangman proc 

     push ax 
     push bx 
     push dx 

     xor bx, bx 
     mov bl, wrongCount
     shl bx, 1
     mov dx, hangPtrs[bx]

     mov ah, 09h
     int 21h

     pop dx
     pop bx
     pop ax

ret 


Print_Hangman endp 


Print_Guessed_Word proc
      push ax
      push dx
      push si 
      lea  si, guessedword


pg_loop:
      mov al, [si]
      cmp al, "$"
      je pg_done 
      mov dl, al 

      mov ah, 02h
      int 21h 

      mov dl, " "
      mov ah, 02h
      int 21h 

      inc si 
      jmp pg_loop 


pg_done:
     pop si 
     pop dx
     pop ax
    
     ret 
     Print_Guessed_word endp


Print_wrong_Letters proc

     push ax
     push cx
     push dx 
     push si
 
     lea si, wrongGuesses
     mov cx, 20

pw_loop:
    
      mov al, [si]
      cmp al, 0 
      je pw_done

      mov dl, al 
      mov ah, 02h 
      int 21h 

     mov dl, " "
     mov ah,02h
     int 21h
     inc si 
     loop pw_loop 

pw_done:
     
     pop si 
     pop dx
     pop cx
     pop ax

     ret 
     Print_wrong_letters endp 


Print_current_word proc
    push ax
    push dx
    push si 

    lea si, currentword


pcw_loop:
    mov al, [si]
    cmp al, "$"
    je pcw_done 

    mov dl, al 
    mov ah, 02h
    int 21h 
    inc si 
    jmp pcw_loop 


pcw_done:
     pop si 
     pop dx 
     pop ax

     ret
     Print_current_word endp


Clear_Screen proc 

     push ax
     push bx
     push cx
     push dx
   
     mov ah, 06h
     mov al, 0
     mov bh, 07h
     mov cx, 0000h
     mov dx, 184fh

     int 10h 
     mov ah, 02h
     mov bh, 0 
     mov dx, 0000h 
     int 10h

     pop dx
     pop cx
     pop bx
     pop ax 

     ret 
     Clear_Screen endp 

end main 