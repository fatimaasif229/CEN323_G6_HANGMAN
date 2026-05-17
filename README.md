# Project Description 

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
- PICK_WORD : Selects and copies random word into game state.
- PROCESS_GUESS : Validates input, updates guessed/wrong arrays, checks win/lose.
- PRINT_HANGMAN : Displyas the correct ASCII art stage based on wrongCount.
- PRINT_GUESSED_WORD : Prints the current _ _ A _ _ style masked word.
- PRINT_WRONG_LETTERS : Lists all incorrect guesses so far.
- CLEAR_SCREEN : Clears the console via BIOS video interrupt.

# Group Contributions

Huraira Minhas — 01-135232-030
- Module: Core Game Logic
- Implemented "Pick_Word" with BIOS clock seeding and LCG random selection
- Wrote "Process_Guess" with duplicate detection and win/loss logic
- Managed "gameOver", "wrongCount", and "guessedCount" state variables


Eman Shoukat — 01-135232-017
- Module: Input & Testing
- Handled keyboard input loop, uppercase conversion and invalid input rejection
- Wrote all test cases and verified correct, wrong and duplicate guess paths
- Debugged the "Find_Slot" logic in wrong guess handling


Fatima Asif — 01-135232-021
- Module: UI & Displays
- Designed all 7 ASCII hangman art stages in the data segment
- Implemented "PRINT_HANGMAN", "Print_Guessed_Word", "Print_Wrong_Letters" and "Clear_Screen"
- Wrote all in-game message strings and formatted the game screen layout

 
# Setup and Run Instructions
  
Requirements
- emu8086 installed on Windows

Steps
1. Clone the repository
   
3. Open emu8086
- Launch the emu8086 application

5. Load the file
- Click File then Open
- Navigate to the cloned folder
- Select hangman.asm

7. Compile
- Click Compile or press F5
- Check the bottom panel for any errors before proceeding

9. Run
- Click Run or press F9
- The emulator screen will open and the game will start

How to Play
- A random word is picked each time you run the program
Type a letter and press Enter to guess
- You have 6 attempts before the game ends
- Both uppercase and lowercase letters are accepted
  
Note
This program runs inside emu8086 only. It will not run natively on modern 
operating systems without an emulator.

