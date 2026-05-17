## Project Description 

HANGMAN GAME - 8086 Assembly (EMU 8086)
A fully functional Hangman word-guessing game written in 8086 Assembly language, designed to run in the EMU 8086 emulator. The game features ASCII art gallows, randomized word selection everytime we play and a complete game loop that runs from start to finish. It is all built on raw x86 interrupts and DOS system calls. 

Description:

This project is a console based Hangman game implemented entirely in x86 16 bit assembly using the .MODEL SMALL memory model. The player must guess a hidden word one letter at a time before the hangman is fully drawn (6 wrong guesses allowed). Every run picks a different word thanks to a Linear Congreuntial Generator (LCG) seeded from the real time BIOS timer. 

Features:
- Random Word Selection - Seed pulled from BIOS INT 1Ah timer at runtime, so the word differs every game.
- 7 stage ASCII hangman art - Gallows progressively draws eith each wrong guess.
- 8 word bank - Words of varying lengths and difficulty.
- Case Insensitive Input - Lowercase letters automatically converted to Uppercase.
- Screen Clearing between Turns - Clean display using BIOS INT 10h scroll.
- Live Game Status - Shows tries remaining, wrong letters guessed, and current word progress.

Key Procedures:
- Pick_Word : Selects and copies random word into game state.
- Process_Guess : Validates input, updates guessed/wrong arrays, checks win/lose.
- Print_Hangman : Displyas the correct ASCII art stage based on wrongCount.
- Print_Guessed_Word : Prints the current _ _ A _ _ style masked word.
- Print_Wrong_Letters : Lists all incorrect guesses so far.
- Clear_Screen : Clears the console via BIOS video interrupt.
