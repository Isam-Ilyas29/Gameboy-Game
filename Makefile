#-------------------------------------------------------------------#

SRC_DIR = Source
RES_DIR = Resources
LIB_DIR = Libraries
OBJ_DIR = Objects
BIN_DIR = Binaries

BGB = $(LIB_DIR)/BGB

#-------------------------------------------------------------------#

MAIN_ASM = $(SRC_DIR)/main.asm
MAIN_OBJ = $(OBJ_DIR)/main.o

GAME_ASM = $(SRC_DIR)/Game/game.asm
GAME_OBJ = $(OBJ_DIR)/game.o

ROM_BIN = $(BIN_DIR)/rom.gb

#-------------------------------------------------------------------#

all:
	rgbasm -o "$(MAIN_OBJ)" "$(MAIN_ASM)"
	rgbasm -o "$(GAME_OBJ)" "$(GAME_ASM)"
	rgblink -o "$(ROM_BIN)" "$(MAIN_OBJ)" "$(GAME_OBJ)"
	rgbfix -v -p 0xFF "$(ROM_BIN)"
	
ifeq ($(OS), Windows_NT)
	"$(BGB)/bgb.exe" "$(BIN_DIR)/rom.gb"
else
	wine "$(BGB)/bgb" "$(BIN_DIR)/rom.gb"
endif

#-------------------------------------------------------------------#
