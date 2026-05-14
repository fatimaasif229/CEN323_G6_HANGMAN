.MODEL SMALL
.STACK 100H

.DATA
    ; -----------------------------------------------
    ; Word Bank (each word padded/ended with $)
    ; -----------------------------------------------
    word0   DB 'EMANPAGAL$'
    word1   DB 'CRISTIANO$'
    word2   DB 'BOBZY'
    word3   DB 'KROOS$'
    word4   DB 'MONITOR$'
    word5   DB 'HURAIRA$'
    word6   DB 'RESUME$'
    word7   DB 'GRIFFIN$'

    wordPtrs DW OFFSET word0, OFFSET word1, OFFSET word2, OFFSET word3,
              DW OFFSET word4, OFFSET word5, OFFSET word6, OFFSET word7

    ; -----------------------------------------------
    ; Game State
    ; -----------------------------------------------
    currentWord DB 20 DUP('$')
    guessedWord DB 20 DUP('_')
    wrongGuesses DB 20 DUP(0)
    wordLen      DB 0
    wrongCount   DB 0
    guessedCount DB 0
    gameOver     DB 0

    ; -----------------------------------------------
    ; Messages
    ; -----------------------------------------------
    msgTitle    DB '=========== HANGMAN GAME ===========', 13, 10, '$'
    msgGuess    DB 13, 10, 'Enter a letter: $'
    msgWrong    DB 13, 10, 'Wrong! Try again.', 13, 10, '$'
    msgCorrect  DB 13, 10, 'Correct!', 13, 10, '$'
    msgAlready  DB 13, 10, 'Already guessed that letter!', 13, 10, '$'
    msgWin      DB 13, 10, '*** YOU WIN! Congratulations! ***', 13, 10, '$'
    msgLose     DB 13, 10, '*** YOU LOSE! Better luck next time! ***', 13, 10, '$'
    msgWord     DB 13, 10, 'The word was: $'
    msgWrongs   DB 13, 10, 'Wrong letters: $'
    msgTries    DB 13, 10, 'Tries left: $'
    msgNewline  DB 13, 10, '$'
    msgEnter    DB 13, 10, 'Press any key to exit...', '$'

    ; Seed is now filled at runtime from the BIOS clock
    randSeed DW 0

    ; -----------------------------------------------
    ; Hangman ASCII Art Stages
    ; -----------------------------------------------
    hang0 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang1 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang2 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang3 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |  /|  ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang4 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |  /|\ ', 13, 10,
           DB '  |      ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang5 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |  /|\ ', 13, 10,
           DB '  |  /   ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hang6 DB '  +---+  ', 13, 10,
           DB '  |   |  ', 13, 10,
           DB '  |   O  ', 13, 10,
           DB '  |  /|\ ', 13, 10,
           DB '  |  / \ ', 13, 10,
           DB '  |      ', 13, 10,
           DB '=========$'

    hangPtrs DW OFFSET hang0, OFFSET hang1, OFFSET hang2, OFFSET hang3,
               DW OFFSET hang4, OFFSET hang5, OFFSET hang6

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; -----------------------------------------------
    ; Seed randSeed from the BIOS timer tick count.
    ; INT 1AH / AH=00H returns:
    ;   CX = high word of tick count
    ;   DX = low  word of tick count
    ; The low word changes every ~55ms so it is
    ; different on every run.  XOR with CX adds
    ; even more variation.
    ; -----------------------------------------------
    MOV AH, 00H
    INT 1AH                 ; CX:DX = tick count
    XOR DX, CX              ; mix high and low words
    MOV randSeed, DX        ; store as our seed

    CALL PICK_WORD

GAME_LOOP:
    CALL CLEAR_SCREEN

    LEA DX, msgTitle
    MOV AH, 09H
    INT 21H

    CALL PRINT_HANGMAN

    LEA DX, msgTries
    MOV AH, 09H
    INT 21H
    MOV AL, 6
    SUB AL, wrongCount
    ADD AL, 30H
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    LEA DX, msgWrongs
    MOV AH, 09H
    INT 21H
    CALL PRINT_WRONG_LETTERS

    LEA DX, msgNewline
    MOV AH, 09H
    INT 21H
    CALL PRINT_GUESSED_WORD

    CMP gameOver, 1
    JE  PLAYER_WON
    CMP gameOver, 2
    JE  PLAYER_LOST

    LEA DX, msgGuess
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H
    MOV BL, AL

    ; Convert to uppercase
    CMP BL, 61H
    JL  SKIP_UPPER
    CMP BL, 7AH
    JG  SKIP_UPPER
    SUB BL, 20H
SKIP_UPPER:

    ; Validate A-Z
    CMP BL, 41H
    JL  GAME_LOOP
    CMP BL, 5AH
    JG  GAME_LOOP

    CALL PROCESS_GUESS
    JMP GAME_LOOP

PLAYER_WON:
    LEA DX, msgWin
    MOV AH, 09H
    INT 21H
    JMP EXIT_GAME

PLAYER_LOST:
    LEA DX, msgLose
    MOV AH, 09H
    INT 21H
    LEA DX, msgWord
    MOV AH, 09H
    INT 21H
    CALL PRINT_CURRENT_WORD

EXIT_GAME:
    LEA DX, msgEnter
    MOV AH, 09H
    INT 21H
    MOV AH, 01H
    INT 21H
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ===============================================================
; PICK_WORD
; Uses the clock-seeded randSeed with LCG, then XOR DX,DX before
; DIV so the remainder is always a clean 0-7 index.
; ===============================================================
PICK_WORD PROC
    ; LCG step: seed = seed * 25173 + 13849
    MOV AX, randSeed
    MOV BX, 25173
    MUL BX              ; 32-bit result in DX:AX
    ADD AX, 13849
    MOV randSeed, AX

    ; Clear DX before DIV so we only divide AX, not DX:AX
    XOR DX, DX
    MOV BX, 8
    DIV BX              ; DX = remainder 0-7
    MOV BX, DX

    SHL BX, 1
    MOV SI, wordPtrs[BX]

    LEA DI, currentWord
    LEA BX, guessedWord
    MOV CX, 0

COPY_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  COPY_DONE
    MOV [DI], AL
    MOV BYTE PTR [BX], '_'
    INC SI
    INC DI
    INC BX
    INC CX
    JMP COPY_LOOP

COPY_DONE:
    MOV [DI], AL
    MOV BYTE PTR [BX], '$'
    MOV wordLen, CL
    MOV wrongCount, 0
    MOV guessedCount, 0
    MOV gameOver, 0

    LEA DI, wrongGuesses
    MOV CX, 20
CLEAR_WRONG:
    MOV BYTE PTR [DI], 0
    INC DI
    LOOP CLEAR_WRONG

    RET
PICK_WORD ENDP

; ===============================================================
; PROCESS_GUESS - BL = guessed letter (uppercase)
; ===============================================================
PROCESS_GUESS PROC
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH DI

    ; Check wrong guesses for duplicate
    LEA SI, wrongGuesses
    MOV CX, 20
CHECK_WRONG_DUP:
    MOV AL, [SI]
    CMP AL, 0
    JE  NOT_IN_WRONG
    CMP AL, BL
    JE  ALREADY_GUESSED
    INC SI
    LOOP CHECK_WRONG_DUP
NOT_IN_WRONG:

    ; Check if already revealed in guessedWord
    LEA SI, guessedWord
CHECK_CORRECT_DUP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  NOT_IN_CORRECT
    CMP AL, BL
    JE  ALREADY_GUESSED
    INC SI
    JMP CHECK_CORRECT_DUP
NOT_IN_CORRECT:

    ; Search for letter in currentWord
    LEA SI, currentWord
    LEA DI, guessedWord
    MOV CX, 0

SEARCH_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  SEARCH_DONE
    CMP AL, BL
    JNE NO_MATCH
    MOV [DI], BL
    INC CX
    INC guessedCount
NO_MATCH:
    INC SI
    INC DI
    JMP SEARCH_LOOP

SEARCH_DONE:
    CMP CX, 0
    JE  WRONG_GUESS

    LEA DX, msgCorrect
    MOV AH, 09H
    INT 21H

    MOV AL, guessedCount
    CMP AL, wordLen
    JGE PLAYER_WINS
    JMP GUESS_DONE

WRONG_GUESS:
    LEA DI, wrongGuesses
    MOV CX, 20
FIND_SLOT:
    MOV AL, [DI]
    CMP AL, 0
    JE  ADD_WRONG
    INC DI
    LOOP FIND_SLOT
    JMP GUESS_DONE
ADD_WRONG:
    MOV [DI], BL
    INC wrongCount

    LEA DX, msgWrong
    MOV AH, 09H
    INT 21H

    CMP wrongCount, 6
    JGE PLAYER_LOSES
    JMP GUESS_DONE

ALREADY_GUESSED:
    LEA DX, msgAlready
    MOV AH, 09H
    INT 21H
    JMP GUESS_DONE

PLAYER_WINS:
    MOV gameOver, 1
    JMP GUESS_DONE

PLAYER_LOSES:
    MOV gameOver, 2

GUESS_DONE:
    POP DI
    POP SI
    POP CX
    POP AX
    RET
PROCESS_GUESS ENDP

; ===============================================================
; PRINT_HANGMAN
; ===============================================================
PRINT_HANGMAN PROC
    PUSH AX
    PUSH BX
    PUSH DX

    XOR BX, BX
    MOV BL, wrongCount
    SHL BX, 1
    MOV DX, hangPtrs[BX]
    MOV AH, 09H
    INT 21H

    POP DX
    POP BX
    POP AX
    RET
PRINT_HANGMAN ENDP

; ===============================================================
; PRINT_GUESSED_WORD
; ===============================================================
PRINT_GUESSED_WORD PROC
    PUSH AX
    PUSH DX
    PUSH SI

    LEA SI, guessedWord
PG_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  PG_DONE
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    INC SI
    JMP PG_LOOP
PG_DONE:
    POP SI
    POP DX
    POP AX
    RET
PRINT_GUESSED_WORD ENDP

; ===============================================================
; PRINT_WRONG_LETTERS
; ===============================================================
PRINT_WRONG_LETTERS PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH SI

    LEA SI, wrongGuesses
    MOV CX, 20
PW_LOOP:
    MOV AL, [SI]
    CMP AL, 0
    JE  PW_DONE
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV DL, ' '
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP PW_LOOP
PW_DONE:
    POP SI
    POP DX
    POP CX
    POP AX
    RET
PRINT_WRONG_LETTERS ENDP

; ===============================================================
; PRINT_CURRENT_WORD
; ===============================================================
PRINT_CURRENT_WORD PROC
    PUSH AX
    PUSH DX
    PUSH SI

    LEA SI, currentWord
PCW_LOOP:
    MOV AL, [SI]
    CMP AL, '$'
    JE  PCW_DONE
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    INC SI
    JMP PCW_LOOP
PCW_DONE:
    POP SI
    POP DX
    POP AX
    RET
PRINT_CURRENT_WORD ENDP

; ===============================================================
; CLEAR_SCREEN
; ===============================================================
CLEAR_SCREEN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV AH, 06H
    MOV AL, 0
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H

    MOV AH, 02H
    MOV BH, 0
    MOV DX, 0000H
    INT 10H

    POP DX
    POP CX
    POP BX
    POP AX
    RET
CLEAR_SCREEN ENDP

END MAIN